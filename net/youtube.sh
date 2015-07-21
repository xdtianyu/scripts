#!/bin/bash

# pip install youtube-dl

URI=$1

AUDIO=$(youtube-dl -F $URI | grep "DASH audio"|grep "aac"|tail -1|cut -d ' ' -f 1)
VIDEO=$(youtube-dl -F $URI | grep "DASH video"|grep "mp4"|tail -1|cut -d ' ' -f 1)

youtube-dl -f $VIDEO+$AUDIO -k $URI
