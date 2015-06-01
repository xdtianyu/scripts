#!/usr/bin/env python

from bs4 import BeautifulSoup

import urllib2

url = 'https://download.cyanogenmod.org/'
soup = BeautifulSoup(urllib2.urlopen(url))

tag = soup.find_all('span')

count = 0

for span in tag:
    if span.get('class')[0] == "codename":
        print str(count) + " * * * * bash /root/bin/cm " + span.string
        count += 2
        if count == 60:
            count = 0
