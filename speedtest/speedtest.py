#!/usr/bin/env python2

import hashlib
import os
import sys

__author__ = 'ty'

import re
import time
from datetime import datetime
from datetime import timedelta
from nvd3 import lineWithFocusChart

MAX_SPEED = 5000


class SpeedObject:
    def __init__(self, _date, _uri, _speed):
        self.date = _date
        self.uri = _uri
        self.speed = _speed

directory = sys.argv[1]
name = sys.argv[2]
test_duration = sys.argv[3]

with open(directory+"/"+name+".txt", 'r') as content_file:
    content = content_file.read()

tests = content.split('#######################')

date = datetime
uri = ""

testDict = {}

for test in tests:
    try:
        item = re.findall("--.*", test, re.MULTILINE)[0]
        time_s = item.split('  ')[0]
        uri = item.split('  ')[1]
        date = datetime.strptime(time_s, '--%Y-%m-%d %H:%M:%S--')

        print date
        print uri

        if uri in testDict:
            speedList = testDict[uri]
        else:
            speedList = []
            testDict[uri] = speedList

        speeds = re.findall(".*%.*", test, re.MULTILINE)

        if len(speeds) == 0:
            continue
        else:
            delta = float(test_duration) / len(speeds)

        speedList.append(SpeedObject(date + timedelta(0, -3), uri, "10K"))

        for speed in speeds:
            speed = speed.split('% ')[1].strip().split(' ')[0]

            if "M" in speed:
                speed_i = float(speed.split('M')[0]) * 1024
                if speed_i > MAX_SPEED:
                    continue
                speed = str(speed_i) + 'K'

            speedList.append(SpeedObject(date, uri, speed))
            date = date + timedelta(0, delta)
            print speed
        speedList.append(SpeedObject(date + timedelta(0, 3), uri, "10K"))

    except IndexError as e:
        pass


output_file = open(directory+'/'+name+'.htm', 'w')

chart_name = "Speed Test"
chart = lineWithFocusChart(name=chart_name, width=1024, color_category='category20b', x_is_date=True,
                           x_axis_format="%d %b %Y %H")

title = "\n\n<h2>" + chart_name + "</h2> "

href = "<a href=\""+name+".htm\">"+name+"</a>"

for filename in os.listdir(directory):
    if filename.endswith('.htm') and filename != name+".htm":
        href = href + " <a href=\""+filename+"\">"+filename[:-4]+"</a>"

href = href + " <a href=\""+name+".txt\">RAW</a>"

chart.set_containerheader(title + href + "\n\n")

extra_series = {"tooltip": {"y_start": "", "y_end": " K/s"},
                "date_format": "%d %b %Y %H:%M:%S %p"}

for uri in testDict:
    speeds = []
    dates = []

    for speed in testDict[uri]:
        dates.append(time.mktime(speed.date.timetuple()) * 1e3 + speed.date.microsecond / 1e3)
        speeds.append(float(speed.speed.split('K')[0]))
    md5 = hashlib.md5(uri).hexdigest()
    color = '#%s' % (md5[-6:])
    chart.add_serie(name=uri, y=speeds, x=dates, extra=extra_series, color=color)

chart.buildhtml()

output_file.write(chart.htmlcontent)

output_file.close()
