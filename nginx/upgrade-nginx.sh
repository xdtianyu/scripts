#!/bin/bash

VERSION="1.10.0"
OLD_VERSION=$(nginx -v 2>&1|cut -d '/' -f 2)

SSL_VERSION="1.0.2g"
ZLIB_VERSION="1.2.8"

cd || exit 1

if [ -d "nginx" ]; then
    echo "mv nginx nginx-$OLD_VERSION"
    mv nginx "nginx-$OLD_VERSION"
fi

mkdir nginx
cd nginx || exit 1

# Download and extract nginx
wget http://nginx.org/download/nginx-$VERSION.tar.gz
tar xf nginx-$VERSION.tar.gz

# Download and extract OpenSSL
wget https://www.openssl.org/source/openssl-$SSL_VERSION.tar.gz
tar xf openssl-$SSL_VERSION.tar.gz

# Download and extract gzip
wget http://zlib.net/zlib-$ZLIB_VERSION.tar.gz
tar xf zlib-$ZLIB_VERSION.tar.gz

# Delete downloads
rm -- *.tar.gz

# Download ngx_http_substitutions_filter_module
git clone https://github.com/yaoweibin/ngx_http_substitutions_filter_module

cd "nginx-$VERSION" || exit 1

./configure \
--with-cc-opt='-g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security -D_FORTIFY_SOURCE=2' \
--with-ld-opt='-Wl,-Bsymbolic-functions -Wl,-z,relro' \
--sbin-path=/usr/sbin/nginx \
--prefix=/usr/share/nginx \
--conf-path=/etc/nginx/nginx.conf \
--http-log-path=/var/log/nginx/access.log \
--error-log-path=/var/log/nginx/error.log \
--lock-path=/var/lock/nginx.lock \
--pid-path=/run/nginx.pid \
--http-client-body-temp-path=/var/lib/nginx/body \
--http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
--http-proxy-temp-path=/var/lib/nginx/proxy \
--http-scgi-temp-path=/var/lib/nginx/scgi \
--http-uwsgi-temp-path=/var/lib/nginx/uwsgi \
--with-debug \
--with-pcre-jit \
--with-ipv6 \
--with-http_ssl_module \
--with-http_stub_status_module \
--with-http_realip_module \
--with-http_addition_module \
--with-http_dav_module \
--with-http_geoip_module \
--with-http_gzip_static_module \
--with-http_image_filter_module \
--with-http_v2_module \
--with-http_sub_module \
--with-http_xslt_module \
--with-mail \
--with-mail_ssl_module \
--with-http_sub_module \
--with-zlib=../zlib-$ZLIB_VERSION \
--with-openssl=../openssl-$SSL_VERSION \
--add-module=../ngx_http_substitutions_filter_module

make

echo "Stop service ..."
service nginx stop
cd /etc || exit 1

if [ -d "nginx-$OLD_VERSION" ]; then
    mv "nginx-$OLD_VERSION" "nginx-$OLD_VERSION-$(date +%m%d%M%S)"
fi

mv nginx "nginx-$OLD_VERSION"
cd - || exit 1

make install

cd /etc || exit 1
mv nginx "nginx-$VERSION"
mv "nginx-$OLD_VERSION" nginx

echo "Start service ..."

service nginx start

echo "Done."
