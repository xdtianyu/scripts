#!/usr/bin/env python3
import os

import qiniu

import config

access_key = config.qn_access_key
secret_key = config.qn_secret_key
bucket_name = config.qn_bucket_name

cos_app_id = config.cos_app_id
cos_bucket_name = config.cos_bucket_name
cos_secret_id = config.cos_secret_id
cos_key = config.cos_key


def upload(name):
    upload_file(name)
    upload_cos(name)


# upload to qiniu
def upload_file(file_name):
    q = qiniu.Auth(access_key, secret_key)

    key = os.path.basename(file_name)

    token = q.upload_token(bucket_name, key)
    ret, info = qiniu.put_file(token, key, file_name)
    if ret is not None:
        print(file_name + ' uploaded.')
    else:
        print(info)


# upload to q-cloud cos
def upload_cos(file):
    headers = {
        'Authorization': sign()
    }
    url = 'https://web.file.myqcloud.com/files/v1/' + cos_app_id + '/' + cos_bucket_name + '/' + os.path.basename(file)
    data = {'op': 'upload', 'insertOnly': '0'}
    files = {'filecontent': open(file, 'rb')}
    import requests
    r = requests.post(url, data=data, files=files, headers=headers)
    print(r.text)


def sign():
    import hmac
    import hashlib

    # a=[appid]&b=[bucket]&k=[SecretID]&e=[expiredTime]&t=[currentTime]&r=[rand]&f=
    import time
    current_time = int(time.time())
    sign_text = 'a=' + cos_app_id + '&b=' + cos_bucket_name + '&k=' + cos_secret_id + '&e=' + str(
        current_time + 3600) + '&t=' + str(current_time) + '&r=123&f='
    sign_tmp = hmac.new(cos_key.encode(), sign_text.encode(), hashlib.sha1).digest() + sign_text.encode()
    import base64

    return base64.b64encode(sign_tmp).decode()

