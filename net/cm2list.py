#!/usr/bin/env python

from bs4 import BeautifulSoup

import urllib2

url = 'https://download.cyanogenmod.org/'
soup = BeautifulSoup(urllib2.urlopen(url))

a_list = soup.find_all('a')

print "codename".ljust(20) + "fullname"

for a in a_list:
    if a.get('class') and a.get('class')[0] == "device":

        spans = a.find_all('span')

        s = ""
        for span in spans:
            if span.get('class')[0] == "codename":
                s = span.string
            if span.get('class')[0] == "fullname":
                s = s.ljust(20) + span.string
        print s
