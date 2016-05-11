#!/bin/bash

VERSION="1.10.0"

if [ ! -z "$1" ]; then
    VERSION="$1"
fi

OLD_VERSION=$(nginx -v 2>&1|cut -d '/' -f 2)

DEB_FILE="nginx_$VERSION-$(lsb_release -sc)-1_amd64.deb"

wget "https://www.xdty.org/dl/vps/nginx_$VERSION-1_amd64.deb -O $DEB_FILE"

echo "Stop service ..."
service nginx stop
cd /etc || exit 1

if [ -d "nginx-$OLD_VERSION" ];then
    mv "nginx-$OLD_VERSION" "nginx-$OLD_VERSION-$(date +%m%d%M%S)"
fi

mv nginx "nginx-$OLD_VERSION"
cd - || exit 1

dpkg --force-overwrite -i "$DEB_FILE"

cd /etc || exit 1
mv nginx "nginx-$VERSION"
mv "nginx-$OLD_VERSION" nginx

echo "Start service ..."

service nginx start

echo "Done."
