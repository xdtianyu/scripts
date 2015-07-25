#!/bin/bash

USER="HTTP_USER"
PASSWORD="HTTP_PASSOWRD"
RPC="https://home.example.com/jsonrpc"
TOKEN="ARIA2_TOKEN"

DOWNLOAD_URLS=(
    https://remote.example.com/downloads/
    https://cdn1.example.com/downloads/
    https://cdn2.example.com/downloads/
    https://cdn3.example.com/downloads/
    https://cdn4.example.com/downloads/
)

export LC_ALL=en_US.UTF-8

FILE="$1"

LINK=""
for URL in "${DOWNLOAD_URLS[@]}"; do
    if [ -z "$LINK" ]; then
        LINK="\"$URL$FILE\""
    else
        LINK="$LINK, \"$URL$FILE\""
    fi
done
curl -s -v --user $USER:$PASSWORD $RPC -X POST -d "[{\"jsonrpc\":\"2.0\",\"method\":\"aria2.addUri\",\"id\":1,\"params\":[\"token:$TOKEN\",[$LINK],{\"split\":\"10\",\"max-connection-per-server\":\"10\",\"seed-ratio\":\"1.0\"}]}]"
