#!/bin/bash

DIR=$1
FILE=$2
DEVICE=$3

mkdir -p $DIR/log
/root/bypy/bypy.py mkdir cm/$DEVICE >> $DIR/log/$DEVICE.log 2>&1
/root/bypy/bypy.py -v --disable-ssl-check -s 10MB upload $DIR/$FILE cm/$DEVICE/$FILE >> $DIR/log/$DEVICE.log 2>&1

rm $DIR/$FILE >> $DIR/log/$DEVICE.log 2>&1
