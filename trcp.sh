#!/bin/bash
# copy complete torrent's *.resume *.torrent file
# Usage:  trcp /media/smb/complete/ /media/wndr4300/transmission/

COMPLETE_DIR=$1
TR_DIR=$2

if [ ! -d "$COMPLETE_DIR" ];then
    echo "Param error."
    exit 0
fi
if [ ! -d "$TR_DIR" ];then
    echo "Param error."
    exit 0
fi

if [ ! -d "$COMPLETE_DIR/../resume" ];then
    mkdir $COMPLETE_DIR/../resume
fi
if [ ! -d "$COMPLETE_DIR/../torrents" ];then
    mkdir $COMPLETE_DIR/../torrents
fi

SAVEIFS=$IFS # setup this case the space char in file name.
IFS=$(echo -en "\n\b")

cd $COMPLETE_DIR
for file in *;do
    echo $file
    if [ $(find $TR_DIR/torrents |grep -F "$file"|wc -l) -gt 1 ];then
        echo -e "\033[0;31mMore than one torrent detected, you may have to check manually.\033[0m"
    fi
    TORRENT=$(find $TR_DIR/torrents |grep -F "$file"|head -n1)
    if [ ! -z "$TORRENT" ];then
        #echo "copy $TORRENT"
        if [ -f "$COMPLETE_DIR/../torrents/$TORRENT" ];then
            echo "file already exist."
        else
            cp "$TORRENT" $COMPLETE_DIR/../torrents
        fi
    else
        echo "error, no torrent find"
    fi
    RESUME=$(find $TR_DIR/resume |grep -F "$file"|head -n1)
    if [ ! -z "$RESUME" ];then
        #echo "copy $RESUME"
        if [ -f "$COMPLETE_DIR/../resume/$RESUME" ];then
            echo "file already exist."
        else
            cp "$RESUME" $COMPLETE_DIR/../resume
        fi
    else
        echo "error, no resume find"
    fi
done

IFS=$SAVEIFS
