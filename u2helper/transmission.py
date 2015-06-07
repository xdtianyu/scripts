# coding=utf-8

import time
import requests
import json
import base64

from bs4 import BeautifulSoup

__author__ = 'ty'

config = json.load(open('config.json'))

download_dir = config["download_dir"]
url = config["transmission_url"]

authorization = base64.b64encode(config["transmission_user"] + ":" +
                                 config["transmission_password"])

target_dir_parent = config["target_dir_parent"]

target_dir = {"Lossless Music": target_dir_parent + u"/音乐/",
              "BDISO": target_dir_parent + u"/动漫/",
              "BDrip": target_dir_parent + u"/动漫/",
              u"外挂结构": target_dir_parent + u"/字幕/",
              "DVDISO": target_dir_parent + u"/动漫/"}

headers = {'X-Transmission-Session-Id': '',
           "Authorization": "Basic " + authorization}

list_payload = '''{"method": "torrent-get", "arguments": {
"fields": ["id", "name", "percentDone","status","downloadDir"]}}'''

r = requests.post(url, headers=headers, data=list_payload, verify=False)

soup = BeautifulSoup(r.text)
code = soup.find("code")
headers['X-Transmission-Session-Id'] = code.text.split(': ')[1]

r = requests.post(url, headers=headers, data=list_payload, verify=False)

result = json.JSONDecoder().decode(r.text)

# print json.dumps(result, indent=2, ensure_ascii=False)

with open("seeding.json") as data_file:
    seedings = json.load(data_file)

for torrent in result["arguments"]["torrents"]:
    if torrent["downloadDir"] == download_dir and torrent["percentDone"] == 1:
        print torrent["name"]

        for seeding in seedings["torrents"]:
            if seeding["folder"] == torrent["name"]:
                if seeding["catalog"] == "Lossless Music" or seeding["catalog"] == u"外挂结构":
                    location_payload = '''{"method": "torrent-set-location", "arguments": {"move": true, "location": "''' + \
                                       target_dir[seeding["catalog"].encode('utf8')] + '''", "ids": [''' + \
                                       str(torrent["id"]) + ''']}}'''
                else:
                    location_payload = '''{"method": "torrent-set-location", "arguments": {"move": true, "location": "''' + \
                                       target_dir[seeding["catalog"]] + \
                                       seeding["name"].encode('utf8') + '''", "ids": [''' + \
                                       str(torrent["id"]) + ''']}}'''
                print location_payload
                r = requests.post(url, headers=headers, data=location_payload, verify=False)
                print r.text
                time.sleep(1)
                break
