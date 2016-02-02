#!/bin/bash

if [ ! -f "$CONFIG" ];then
    echo "ERROR, CONFIG NOT EXIST."
    exit 1
fi 

. $CONFIG

echo $DOMAINS > domains.txt

./letsencrypt.sh -c -k ./cloudxns-hook.sh -t dns-01
