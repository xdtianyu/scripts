#!/bin/bash
# Convert lighttpd autoindex url to download link.
if [ -z "$1" ];then
    echo "Error param."
    exit 0
fi

URL=$1

if [ -z "$2" ];then
    curl -k -s $URL | sed -n "s|.*href=\"\([^\"]*\).*|$URL\1|p"
else
    if [ "$2"=="--auth" ];then
        if [ -z "$3" ];then
            echo "Error user."
            exit 0
        fi
        if [ -z "$4" ];then
            echo "Error password."
            exit 0
        fi
        curl -k -s -u $3:$4 $URL | sed -n "s|.*href=\"\([^\"]*\).*|$URL\1|p" 
        exit 0
    fi
fi
