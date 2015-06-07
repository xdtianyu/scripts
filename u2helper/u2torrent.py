#!/usr/bin/env python

__author__ = 'ty'

import json

class U2Torrent:
    title = ""
    id = 0
    catalog = ""
    description = ""
    name = ""
    folder = ""

    def __init__(self):
        pass

    def json(self):
        return json.dumps(self, default=lambda o: o.__dict__, ensure_ascii=False).encode('utf8')
