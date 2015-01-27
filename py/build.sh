#!/bin/bash

USER=$(cat /etc/passwd |grep bash| grep home|head -n1 |cut -d ':' -f 1)

if [ -z '$USER' ];then
    echo 'Error, must have a normal user!!'
    exit 0
else
    echo "Run as $USER now."
fi

if [ -d '/tmp/rtmpweb' ];then
    rm -r /tmp/rtmpweb
fi

sudo -u $USER mkdir /tmp/rtmpweb
sudo -u $USER cp -a . /tmp/rtmpweb

cd /tmp/rtmpweb

echo -e "cleaning...\n"
sudo -u $USER ./clean.sh

sudo -u $USER python server.py -c server.cfg -g
sudo -u $USER pyinstaller server.py -F

if [ -f '.auto' ];then
    sudo -u $USER cp .auto dist
else 
    echo "Error, .auto file not find"
fi

if [ ! -d 'dist' ];then
    echo "Error, pyinstall failed!"
    exit 0
fi

if [ -d 'records' ];then
    sudo -u $USER cp -r records dist
fi

if [ -d 'static' ];then
    sudo -u $USER cp -r static dist
else
    echo "Error, no static."
fi

if [ -f 'server.cfg' ];then
    sudo -u $USER cp server.cfg dist
fi

cd -

echo "DONE!"
