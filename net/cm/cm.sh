#!/bin/bash

DIR=$1
DEVICE=$2
rm
/root/bypy/bypy.py -v --disable-ssl-check -s 10MB syncup $DIR cm/$DEVICE

rm -r $DIR
