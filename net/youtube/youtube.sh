#!/bin/bash

DOWNLOAD_DIR="YOUR_DOWNLOAD_DIR"
USER="HTTP_USER"
PASSWORD="HTTP_PASSWORD"
RPC="https://home.example.com/jsonrpc"
TOKEN="ARIA2_TOKEN"

DOWNLOAD_URLS=(
    https://cdn1.example.com/downloads/
    https://cdn2.example.com/downloads/
    https://cdn3.example.com/downloads/
    https://cdn4.example.com/downloads/
)

URI=$1

export LC_ALL=en_US.UTF-8

cd "$DOWNLOAD_DIR"

AUDIO=$(youtube-dl -F $URI | grep "DASH audio"|grep "aac\|webm"|tail -1|cut -d ' ' -f 1)
VIDEO=$(youtube-dl -F $URI | grep "DASH video\|video only"|grep "mp4"|tail -1|cut -d ' ' -f 1)

youtube-dl -v -f $VIDEO+$AUDIO -k $URI

NAME=$(echo "$URI" |cut -d '=' -f 2)

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

FILES=($(ls -- *$NAME*))

for FILE in "${FILES[@]}"; do
    LINK=""
    for URL in "${DOWNLOAD_URLS[@]}"; do
        if [ -z "$LINK" ]; then
            LINK="\"$URL$FILE\""
        else
            LINK="$LINK, \"$URL$FILE\""
        fi
    done
    curl -v --user $USER:$PASSWORD $RPC -X POST -d "[{\"jsonrpc\":\"2.0\",\"method\":\"aria2.addUri\",\"id\":1,\"params\":[\"token:$TOKEN\",[$LINK],{\"split\":\"10\",\"max-connection-per-server\":\"10\",\"seed-ratio\":\"1.0\"}]}]"
done

IFS=$SAVEIFS
