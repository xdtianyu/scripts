#!/bin/bash

URI=$1

export LC_ALL=en_US.UTF-8

AUDIO=$(youtube-dl -F $URI | grep "DASH audio"|grep "aac"|tail -1|cut -d ' ' -f 1)
VIDEO=$(youtube-dl -F $URI | grep "DASH video"|grep "mp4"|tail -1|cut -d ' ' -f 1)

youtube-dl -v -f $VIDEO+$AUDIO -k $URI

NAME=$(echo "$URI" |cut -d '=' -f 2)

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

FILES=($(ls -- *$NAME*))

for FILE in "${FILES[@]}"; do
    echo $FILE
done

IFS=$SAVEIFS
