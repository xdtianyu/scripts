#!/bin/bash

LINK="$1"
NAME="$2"

echo "$LINK" "$NAME"

ARIA2_RPC=/etc/transmission-daemon/aria2-rpc.sh
X2T=/etc/transmission-daemon/x2t.sh

export LC_ALL=en_US.UTF-8

cd /home/downloads

wget "$LINK" -O "$NAME"

if [ -f "$NAME" ]; then
    # handle file
    EXT="${NAME##*.}"
    if [ "$EXT" = "zip" ]; then
        echo "$X2T -z $NAME"
        $X2T -z "$NAME"
        rm "$NAME"
    elif [ "$EXT" = "rar" ]; then
        echo "$X2T -r $NAME"
        $X2T -r "$NAME"
        rm "$NAME"
    else
        echo "$ARIA2_RPC $NAME"
        $ARIA2_RPC "$NAME"
    fi
else 
    echo "File not found."
fi
