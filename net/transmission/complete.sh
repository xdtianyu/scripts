#!/bin/bash

USER=RPC_USER
PASSWORD=RPC_PASSWORD
OUTPUT=/tmp/tr.complete.txt
UNCOMPRESS_OUTPUT=/tmp/uncompress.txt
X2T=/etc/transmission-daemon/x2t.sh

echo "$TR_APP_VERSION $TR_TIME_LOCALTIME $TR_TORRENT_DIR $TR_TORRENT_HASH $TR_TORRENT_ID $TR_TORRENT_NAME" >>$OUTPUT

cd "$TR_TORRENT_DIR"

if [ -f "$TR_TORRENT_DIR/$TR_TORRENT_NAME" ]; then
    
    EXT="${TR_TORRENT_NAME##*.}"
    if [ "$EXT"="zip" ]; then
        echo "$X2T -z $TR_TORRENT_NAME" >>$OUTPUT
        $X2T -z "$TR_TORRENT_NAME" >>$UNCOMPRESS_OUTPUT
    elif [ "$EXT"="rar" ]; then
        echo "$X2T -r $TR_TORRENT_NAME" >>$OUTPUT
        $X2T -r "$TR_TORRENT_NAME" >>$UNCOMPRESS_OUTPUT
    fi

    echo "remove $TR_TORRENT_NAME" >>$OUTPUT
    transmission-remote --auth $USER:$PASSWORD -t $TR_TORRENT_ID --remove-and-delete >>$OUTPUT 2>&1
else
    echo "unknow file format: $TR_TORRENT_NAME" >>$OUTPUT
fi
