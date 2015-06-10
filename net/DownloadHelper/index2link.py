#!/usr/bin/env python

import os
import requests
import json
import base64

from bs4 import BeautifulSoup

__author__ = 'ty'

config = json.load(open('config.json'))

authorization = base64.b64encode(config["http_user"] + ":" +
                                 config["http_password"])

url = config["url"]

file_type = config["file_type"]
mirror = config["mirror"]

headers = {"Authorization": "Basic " + authorization}

link_list = []


def list_dir(target_url):
    r = requests.get(target_url, headers=headers, verify=True)

    soup = BeautifulSoup(r.text)

    links = soup.find_all("a")

    for link in links:
        href = link.get('href')

        if href == "../":
            continue

        if href.endswith('/'):
            list_dir(target_url + href)
        else:
            link_list.append(target_url + href)


list_dir(url)

link_list.sort(key=os.path.splitext)
link_list.sort(key=lambda f: os.path.splitext(f)[1])

for l in link_list:

    if any(os.path.splitext(l)[1].lower() in s for s in file_type):

        download_link = l

        for m in mirror:
            download_link += " " + l.replace(url, m)
        print download_link + "\n"
