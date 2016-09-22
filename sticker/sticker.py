#!/usr/bin/env python3

import os
import urllib.request
from PIL import Image

import requests
from urllib3.exceptions import HTTPError


user_agent = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko)Chrome/50.0.2661.75 Safari/537.36'

header = {'User-Agent': user_agent}

cache_dir = 'cache/'


def fetch(url, headers, cookies):
    print('fetch: ' + url)

    r = requests.get(url, headers=headers, cookies=cookies)
    from bs4 import BeautifulSoup
    import lxml

    bs = BeautifulSoup(r.text, lxml.__name__)

    name = bs.find('title').text.split(' -')[0]

    print('name: ' + name)

    import re

    spans = bs.find_all('span', style=re.compile('129px;'))

    for span in spans:
        link = re.match('.*(https.*png)', span.get('style')).group(1)
        download(name, link)

    if spans:
        pass
    else:
        print('Error html content!')
        print(r.text)


def download(dir_name, url):
    print('download: ' + url)

    if not os.path.exists(cache_dir + dir_name):
        os.makedirs(cache_dir + dir_name)

    res = None
    try:
        res = urllib.request.urlopen(url)
    except HTTPError:
        print('download error.')

    file_name = url.split('/')[-1]

    path = cache_dir + dir_name + '/' + file_name

    with open(path, 'b+w') as f:
        f.write(res.read())

    scale(path)


def scale(file):
    print('scale: ' + file)
    img = Image.open(file)
    width = 512
    p = (width / float(img.size[0]))
    height = int((float(img.size[1]) * float(p)))
    img.resize((width, height), Image.CUBIC).save(file.split('.')[0]+"_big.png")


if __name__ == '__main__':
    import sys

    if len(sys.argv) > 1 and sys.argv[1]:
        fetch(sys.argv[1], header, {})
    else:
        print('Error parameter.')



