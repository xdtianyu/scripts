#!/bin/bash

export CONFIG=$1

if [ -f "$CONFIG" ];then
    . "$CONFIG"
    DIRNAME=$(dirname "$CONFIG")
    cd "$DIRNAME" || exit 1
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
    wget https://raw.githubusercontent.com/lukas2511/dehydrated/master/dehydrated -O letsencrypt.sh -o /dev/null
    chmod +x letsencrypt.sh
fi

./letsencrypt.sh --register --accept-terms

if [ "$ECC" = "TRUE" ];then
    ./letsencrypt.sh -c -k ./cloudxns-hook.sh -t dns-01 -a secp384r1
else
    ./letsencrypt.sh -c -k ./cloudxns-hook.sh -t dns-01
fi
