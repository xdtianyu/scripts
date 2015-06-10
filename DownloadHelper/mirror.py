#!/usr/bin/env python

import json
import sys

__author__ = 'ty'

config = json.load(open('config.json'))
mirror = config["mirror"]
url = config["url"]

l = sys.argv[1]

download_link = l

for m in mirror:
    download_link += " " + l.replace(url, m)
print download_link + "\n"
