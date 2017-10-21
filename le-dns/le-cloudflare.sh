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

if [ ! -f "cloudflare.sh" ];then
    wget https://github.com/xdtianyu/scripts/raw/master/le-dns/cloudflare.sh -O cloudflare.sh -o /dev/null
    chmod +x cloudflare.sh
fi

if [ ! -f "cloudflare-hook.sh" ];then
    wget https://github.com/xdtianyu/scripts/raw/master/le-dns/cloudflare-hook.sh -O cloudflare-hook.sh -o /dev/null
    chmod +x cloudflare-hook.sh
fi

if [ ! -f "letsencrypt.sh" ];then
    wget https://raw.githubusercontent.com/lukas2511/dehydrated/master/dehydrated -O letsencrypt.sh -o /dev/null
    chmod +x letsencrypt.sh
fi

if [ "$ECC" = "TRUE" ];then
    ./letsencrypt.sh -c -k ./cloudflare-hook.sh -t dns-01 -a secp384r1
else
    ./letsencrypt.sh -c -k ./cloudflare-hook.sh -t dns-01
fi

chown -R www-data:www-data certs
