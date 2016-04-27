#!/bin/bash

VERSION="1.10.0"
OLD_VERSION=$(nginx -v 2>&1|cut -d '/' -f 2)

wget https://www.xdty.org/dl/vps/nginx_$VERSION-1_amd64.deb -O nginx_$VERSION-1_amd64.deb

echo "Stop service ..."
service nginx stop
cd /etc || exit 1

if [ -d "nginx-$OLD_VERSION" ];then
    mv "nginx-$OLD_VERSION" "nginx-$OLD_VERSION-$(date +%m%d)"
fi

mv nginx "nginx-$OLD_VERSION"
cd - || exit 1

dpkg -i nginx_"$VERSION"-1_amd64.deb

cd /etc || exit 1
mv nginx "nginx-$VERSION"
mv "nginx-$OLD_VERSION" nginx

echo "Start service ..."

service nginx start

echo "Done."
