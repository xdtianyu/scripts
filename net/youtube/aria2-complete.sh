#!/bin/bash

USER=HTTP_USER
PASSWORD=HTTP_PASSWORD
API_URI=https://remote.example.com/rm/

echo "$3" >>/tmp/aria2-complete.txt

FILENAME=$(basename "$3")
curl -s -v --user $USER:$PASSWORD $API_URI -X POST -d "files=$FILENAME" --capath /etc/ssl/certs/ >>/tmp/aria2.txt 2>&1
