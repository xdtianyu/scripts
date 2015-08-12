#!/bin/bash

USER=HTTP_USER
PASSWORD=HTTP_PASSWORD
API_URI=https://remote.example.com/rm/

DOWNLOAD_DIR="YOUR_DOWNLOAD_DIR" # e.g. /mnt/usb/download
SORT_DIR="YOUR_SORT_DIR" #e.g. /mnt/usb/complete

OUTOUT="/tmp/aria2-complete.txt"

echo "$3" >>$OUTOUT

# remove file from server
FILENAME=$(basename "$3")
curl -s -v --user $USER:$PASSWORD $API_URI -X POST --data-urlencode "files=$FILENAME" --capath /etc/ssl/certs/ >>/tmp/aria2.txt 2>&1

# sort out files (mp4/m4a/tar/zip)

if [ ! -f "$DOWNLOAD_DIR/$FILENAME" ];then
    echo "$DOWNLOAD_DIR/$FILENAME not exists, exit." >>$OUTOUT
    exit 0
fi

# wait for other sort jobs done.

while [ -f /tmp/.sort ]
do
    echo "wait other job exit" >>$OUTOUT
    #sleep 2
    sleep $[ ( $RANDOM % 10 ) + 1 ]
done

umask 000

touch /tmp/.sort

EXT="${FILENAME##*.}"

MON="$(date +%m)"
DAY="$(date +%m%d)"

if [ "$EXT" = "zip" ];then
    echo "unzip" >>$OUTOUT
    # TODO add zip support
elif [ "$EXT" = "tar" ];then
    echo "tar xvf \"$FILENAME\" -C \"$SORT_DIR/$MON/$DAY\"" >>$OUTOUT
    mkdir -p "$SORT_DIR/archives/$DAY"
    mv "$DOWNLOAD_DIR/$FILENAME" "$SORT_DIR/archives/$DAY"
    TARGET_DIR="$SORT_DIR/$MON/$DAY"
    if [ $(tar tvf "$SORT_DIR/archives/$DAY/$FILENAME"|grep -E '.mp4$|.wmv$|.avi$'|wc -l) -gt 0 ];then
        TARGET_DIR="$SORT_DIR/$MON/$DAY-2"
    fi
    mkdir -p "$TARGET_DIR"
    tar xvf "$SORT_DIR/archives/$DAY/$FILENAME" -C "$TARGET_DIR" >>$OUTOUT 2>&1
elif [ "$EXT" = "mp4" -o "$EXT" = "m4a" ];then
    SUBDIR=""
    
    if [ $(echo "$FILENAME"|grep "\.f[0-9]...mp4"|wc -l) -eq 1 ];then
        SUBDIR="video"
    fi

    if [ $(echo "$FILENAME"|grep "\.f[0-9]...m4a"|wc -l) -eq 1 ];then
        SUBDIR="audio"
    fi
    
    if [ $(echo "$FILENAME"|grep "MMD"|wc -l) -eq 1 ];then
        echo "mv \"$FILENAME\" \"$SORT_DIR/MMD/$DAY/$SUBDIR\"" >>$OUTOUT
        mkdir -p "$SORT_DIR/MMD/$DAY/$SUBDIR"
        mv "$DOWNLOAD_DIR/$FILENAME" "$SORT_DIR/MMD/$DAY/$SUBDIR"
    elif [ $(echo "$FILENAME"|grep "AMV"|wc -l) -eq 1 ];then
        echo "mv \"$FILENAME\" \"$SORT_DIR/AMV/$DAY/$SUBDIR\"" >>$OUTOUT
        mkdir -p "$SORT_DIR/AMV/$DAY/$SUBDIR"
        mv "$DOWNLOAD_DIR/$FILENAME" "$SORT_DIR/AMV/$DAY/$SUBDIR"
    else
        echo "mv \"$FILENAME\" \"$SORT_DIR/TV/$DAY/$SUBDIR\"" >>$OUTOUT
        mkdir -p "$SORT_DIR/TV/$DAY/$SUBDIR"
        mv "$DOWNLOAD_DIR/$FILENAME" "$SORT_DIR/TV/$DAY/$SUBDIR"
    fi
else
    echo "unknown file type: $EXT" >>$OUTOUT
fi

sync
rm /tmp/.sort
