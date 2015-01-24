#!/bin/bash
URL=$1
TARGET=$2
DIRECTORY=$3
BYPY='/root/bypy/bypy.py'

URL=$(curl -k -s $URL |grep $TARGET |grep -v html| sed -n "s|.*href=\"\([^\"]*\).*|$URL\1|p")

if [ -z "$URL" ];then
    echo "ERROR"
    exit 0
fi

echo $URL
ZIP="${URL##*/}"
echo $ZIP

if [ -f "$DIRECTORY/$ZIP" ];then 
    echo "DOWNLOADED"
    exit 0
fi

if [ ! -d "$DIRECTORY" ];then
    echo "ERROR DIR"
    exit 0
fi

cd $DIRECTORY

wget $URL > $ZIP.wget.log 2>&1

md5sum $ZIP > $ZIP.md5

$BYPY -v -s 10MB syncup . cyanogenmod

if [ -f "$DIRECTORY/$ZIP" ];then
    rm "$DIRECTORY/$ZIP"
fi

if [ -f "$DIRECTORY/$ZIP.md5" ];then
    rm "$DIRECTORY/$ZIP.md5"
fi

if [ -f "$DIRECTORY/$ZIP.wget.log" ];then
    rm "$DIRECTORY/$ZIP.wget.log"
fi


cd -
