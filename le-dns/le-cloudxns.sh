#!/bin/bash

export CONFIG=$1

if [ -f "$CONFIG" ];then
    . $CONFIG
    cd $(dirname $CONFIG)
else
    echo "ERROR CONFIG."
    exit 1
fi

echo "$CERT_DOMAINS" > domains.txt

if [ ! -f "cloudxns.sh" ];then
    wget https://github.com/xdtianyu/scripts/raw/master/le-dns/cloudxns.sh -O cloudxns.sh -o /dev/null
    chmod +x cloudxns.sh
fi

if [ ! -f "cloudxns-hook.sh" ];then
    wget https://github.com/xdtianyu/scripts/raw/master/le-dns/cloudxns-hook.sh -O cloudxns-hook.sh -o /dev/null
    chmod +x cloudxns-hook.sh
fi

if [ ! -f "letsencrypt.sh" ];then
    wget https://github.com/lukas2511/letsencrypt.sh/raw/master/letsencrypt.sh -O letsencrypt.sh -o /dev/null
    chmod +x letsencrypt.sh
fi

./letsencrypt.sh -c -k ./cloudxns-hook.sh -t dns-01
