#!/bin/bash
# Please read cm.sh and cyanogenmod.crontab.list too.

URL=$1
DEVICE=$2
TARGET=$DEVICE.zip
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
    mkdir -p "$DIRECTORY"
fi

if [ -f "$DIRECTORY/$ZIP.done" ];then 
    echo "UPLOADED"
    exit 0
fi

cd $DIRECTORY

touch none.done

for file in *.done;do
    echo "REMOVE $file"
    rm $file
done

wget $URL > $ZIP.wget.log 2>&1

md5sum $ZIP > $ZIP.md5

$BYPY -v --disable-ssl-check -s 10MB syncup . cm/$DEVICE

if [ -f "$DIRECTORY/$ZIP" ];then
    rm "$DIRECTORY/$ZIP"
fi

if [ -f "$DIRECTORY/$ZIP.md5" ];then
    rm "$DIRECTORY/$ZIP.md5"
fi

if [ -f "$DIRECTORY/$ZIP.wget.log" ];then
    rm "$DIRECTORY/$ZIP.wget.log"
fi

touch "$DIRECTORY/$ZIP.done"


cd -
