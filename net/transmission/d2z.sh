#!/bin/bash

X2T=/etc/transmission-daemon/x2t.sh
ARIA2_RPC=/etc/transmission-daemon/aria2-rpc.sh

export LC_ALL=en_US.UTF-8

while [ -f /tmp/.d2t ]
do
    echo "wait other job exit"
    sleep 2
done

touch /tmp/.d2t

if [ "$#" -eq 2 ]; then
    DIR=$(basename "$2")
    OPT="$1"
else
    DIR=$(basename "$1")
    OPT="-o"
fi

chmod -R a+rwX "$DIR"
zip -r -0 "$DIR.zip" "$DIR"

if [ "$OPT" = "-z" ]; then
    mv "$DIR" "$DIR-tmp"
    $X2T -z "$DIR.zip"
    rm "$DIR.zip"
    mv "$DIR-tmp" "$DIR"
else
    $ARIA2_RPC "$DIR.zip"
fi

sync
rm /tmp/.d2t
