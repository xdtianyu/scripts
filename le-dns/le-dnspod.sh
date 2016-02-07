#!/bin/bash

export CONFIG=$1

if [ -f "$CONFIG" ];then
    . "$CONFIG"
    cd "$(dirname $CONFIG)" || exit 1
else
    echo "ERROR CONFIG."
    exit 1
fi

echo "$CERT_DOMAINS" > domains.txt

if [ ! -f "dnspod.sh" ];then
    wget https://github.com/xdtianyu/scripts/raw/master/le-dns/dnspod.sh -O dnspod.sh -o /dev/null
    chmod +x dnspod.sh
fi

if [ ! -f "dnspod-hook.sh" ];then
    wget https://github.com/xdtianyu/scripts/raw/master/le-dns/dnspod-hook.sh -O dnspod-hook.sh -o /dev/null
    chmod +x dnspod-hook.sh
fi

if [ ! -f "letsencrypt.sh" ];then
    wget https://github.com/lukas2511/letsencrypt.sh/raw/master/letsencrypt.sh -O letsencrypt.sh -o /dev/null
    chmod +x letsencrypt.sh
fi

./letsencrypt.sh -c -k ./dnspod-hook.sh -t dns-01
