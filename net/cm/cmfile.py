#!/usr/bin/env python3

__author__ = 'ty'

import json

class CMFile:
    url = ""
    sha1 = ""

    def __init__(self):
        pass

    def json(self):
        return json.dumps(self, default=lambda o: o.__dict__, ensure_ascii=False, sort_keys=True)
