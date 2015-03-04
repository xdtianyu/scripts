#!/bin/bash
DEVICE=$1
/root/bin/cmurl http://download.cyanogenmod.org $DEVICE /var/cyanogenmod/$DEVICE >>/var/cyanogenmod-log/$DEVICE.crontab.log 2>&1
