#!/bin/bash

USER=RPC_USER
PASSWORD=RPC_PASSWORD
OUTPUT=/tmp/tr.complete.txt
UNCOMPRESS_OUTPUT=/tmp/uncompress.txt
X2T=/etc/transmission-daemon/x2t.sh
D2Z=/etc/transmission-daemon/d2z.sh
ARIA2_RPC=/etc/transmission-daemon/aria2-rpc.sh
TARGET_DIR=/home/downloads
REMOVE="true"

export LC_ALL=en_US.UTF-8

echo "$TR_APP_VERSION $TR_TIME_LOCALTIME $TR_TORRENT_DIR $TR_TORRENT_HASH $TR_TORRENT_ID $TR_TORRENT_NAME" >>$OUTPUT

if [ "$TR_TORRENT_DIR" != "$TARGET_DIR" ]; then
    #echo "Not in $TARGET_DIR, exit" >>$OUTPUT
    #exit 0
    echo "Not in $TARGET_DIR, copy file now." >>$OUTPUT
    cp -r "$TR_TORRENT_DIR/$TR_TORRENT_NAME" "$TARGET_DIR"
    TR_TORRENT_DIR="$TARGET_DIR"
    REMOVE="false"
fi

cd "$TR_TORRENT_DIR"

if [ -f "$TR_TORRENT_DIR/$TR_TORRENT_NAME" ]; then
    # handle file
    REMOVE_PARAM="--remove-and-delete"
    EXT="${TR_TORRENT_NAME##*.}"
    if [ "$EXT" = "zip" ]; then
        echo "$X2T -z $TR_TORRENT_NAME" >>$OUTPUT
        $X2T -z "$TR_TORRENT_NAME" >>$UNCOMPRESS_OUTPUT
    elif [ "$EXT" = "rar" ]; then
        echo "$X2T -r $TR_TORRENT_NAME" >>$OUTPUT
        $X2T -r "$TR_TORRENT_NAME" >>$UNCOMPRESS_OUTPUT
    else
        echo "$ARIA2_RPC $TR_TORRENT_NAME" >>$OUTPUT
        REMOVE_PARAM="--remove"
        $ARIA2_RPC "$TR_TORRENT_NAME" >>$UNCOMPRESS_OUTPUT
    fi

    echo "remove $TR_TORRENT_NAME" >>$OUTPUT
    if [ "$REMOVE" == "true" ]; then
        transmission-remote --auth $USER:$PASSWORD -t $TR_TORRENT_ID $REMOVE_PARAM >>$OUTPUT 2>&1
    fi
elif [ -d "$TR_TORRENT_DIR/$TR_TORRENT_NAME" ]; then
    # handle dir
    IMAGE_COUNT=$(find "$TR_TORRENT_NAME" -name '*' -exec file {} \; | grep -o -P '^.+: \w+ image'|wc -l)
    if [ $IMAGE_COUNT -gt 10 ];then
        # d2z and compress
        echo "$D2Z -z $TR_TORRENT_NAME" >>$OUTPUT
        $D2Z -z "$TR_TORRENT_NAME"
    else 
        # d2z only
        echo "$D2Z "$TR_TORRENT_NAME"" >>$OUTPUT
        $D2Z "$TR_TORRENT_NAME"
    fi
    if [ "$REMOVE" == "true" ]; then
        transmission-remote --auth $USER:$PASSWORD -t $TR_TORRENT_ID --remove-and-delete >>$OUTPUT 2>&1
    fi
else
    echo "Unknow file format: $TR_TORRENT_NAME" >>$OUTPUT
fi

