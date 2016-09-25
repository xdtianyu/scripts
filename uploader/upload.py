#!/usr/bin/env python3
import os

import config
import uploader


def upload(targets):
    for target in targets:

        if os.path.isdir(target):
            upload([os.path.join(target, f) for f in os.listdir(target)])
        else:
            if os.path.exists(target):
                uploader.upload(target)

upload(config.targets)
