#!/bin/bash
# Convert nginx autoindex url to download link.
if [ -z "$1" ];then
    echo "Error param."
    exit 0
fi

URL=$1

for uri in $(curl -k -s $URL |grep '<a href' |grep -o "\".*\"");do
    echo "$URL${uri//\"}"
done
