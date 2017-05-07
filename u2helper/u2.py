#!/usr/bin/env python
import time
import io

from bs4 import BeautifulSoup
from bs4 import Tag

from u2torrent import U2Torrent

import requests
import itertools
import json

__author__ = 'ty'

config = json.load(open('config.json'))

url = 'https://u2.dmhy.org/getusertorrentlistajax.php?userid='+config["uid"]+'&type=seeding'

info_url = 'https://u2.dmhy.org/torrent_info.php?id='

cookies = dict(
    nexusphp_u2=config["nexusphp_u2"],
    __cfduid=config["__cfduid"])

r = requests.get(url, cookies=cookies)

soup = BeautifulSoup(r.text, "html.parser")

td_list = soup.find_all('td', {'class': 'rowfollow nowrap'})

table_list = soup.find_all('table', {'class': 'torrentname'})

torrents_dict = {}
torrents = []

count = 0

for td, table in itertools.izip(td_list, table_list):

    catalog = ""
    for s in td.contents[0].contents:
        if isinstance(s, Tag):
            catalog += " "
        else:
            catalog = catalog + s
    u2torrent = U2Torrent()

    u2torrent.catalog = catalog
    u2torrent.title = table.find('b').string
    u2torrent.description = table.find('span').string

    u2torrent.id = int(table.find('a').get('href').split('&')[0].split('=')[1])

    print info_url + str(u2torrent.id)

    try:
        info_r = requests.get(info_url + str(u2torrent.id), cookies=cookies)
        info_soup = BeautifulSoup(info_r.text, "html.parser")

        info_name = info_soup.find("span", {'class': 'title'}, text="[name]").parent.find("span", {'class': 'value'})
        u2torrent.folder = info_name.text

        u2torrent.name = u2torrent.title.split('][')[0].replace('[', '')

        print u2torrent.name + " : " + u2torrent.folder

        torrents.append(json.JSONDecoder().decode(u2torrent.json()))
        count += 1
    except Exception as e:
        print str(e)
        print "Fetch folder name failed: " + u2torrent.title
    # time.sleep(3)

torrents_dict["count"] = count
torrents_dict["torrents"] = torrents

with io.open('seeding.json', 'w', encoding='utf-8') as f:
    f.write(unicode(json.dumps(torrents_dict, indent=2, ensure_ascii=False)))
