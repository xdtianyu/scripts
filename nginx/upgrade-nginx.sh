#!/bin/bash

VERSION="1.10.0"

if [ ! -z "$1" ];then
	VERSION="$1"
fi

echo "Start building nginx-$VERSION ..."

OLD_VERSION=$(nginx -v 2>&1|cut -d '/' -f 2)

cd || exit 1

if [ -d "nginx" ]; then
    echo "mv nginx nginx-$OLD_VERSION"
    mv nginx "nginx-$OLD_VERSION"
fi

mkdir nginx
cd nginx || exit 1

# Download and extract nginx
wget "http://nginx.org/download/nginx-$VERSION.tar.gz"
tar xf "nginx-$VERSION.tar.gz"

# Delete downloads
rm -- *.tar.gz

# Download ngx_http_auth_pam_module
git clone https://github.com/stogh/ngx_http_auth_pam_module \
"nginx-$VERSION/modules/nginx-auth-pam"

# Download nginx-dav-ext-module
git clone https://github.com/arut/nginx-dav-ext-module \
"nginx-$VERSION/modules/nginx-dav-ext-module"

# Download echo-nginx-module
git clone https://github.com/openresty/echo-nginx-module \
"nginx-$VERSION/modules/nginx-echo"

# Download nginx-upstream-fair
git clone https://github.com/gnosek/nginx-upstream-fair \
"nginx-$VERSION/modules/nginx-upstream-fair"

# Download ngx_http_substitutions_filter_module
git clone https://github.com/yaoweibin/ngx_http_substitutions_filter_module \
"nginx-$VERSION/modules/ngx_http_substitutions_filter_module"

# Download nginx-module-vts
git clone https://github.com/vozlt/nginx-module-vts \
"nginx-$VERSION/modules/nginx-module-vts"

cd "nginx-$VERSION" || exit 1

U_VERSION=$(lsb_release -rs)

CC_OPT="-g -O2 -fPIE -fstack-protector -Wformat -Werror=format-security -D_FORTIFY_SOURCE=2"
LD_OPT="-Wl,-Bsymbolic-functions -fPIE -pie -Wl,-z,relro -Wl,-z,now"

if [ "$U_VERSION" = "16.04" ];then
    CC_OPT="-g -O2 -fPIE -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2"
fi

./configure \
--with-cc-opt="$CC_OPT" \
--with-ld-opt="$LD_OPT" \
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
--with-http_auth_request_module \
--with-http_addition_module \
--with-http_dav_module \
--with-http_geoip_module \
--with-http_gunzip_module \
--with-http_gzip_static_module \
--with-http_image_filter_module \
--with-http_v2_module \
--with-http_sub_module \
--with-http_xslt_module \
--with-stream \
--with-stream_ssl_module \
--with-mail \
--with-mail_ssl_module \
--with-threads \
--add-module=modules/nginx-auth-pam \
--add-module=modules/nginx-dav-ext-module \
--add-module=modules/nginx-echo \
--add-module=modules/nginx-upstream-fair \
--add-module=modules/ngx_http_substitutions_filter_module \
--add-module=modules/nginx-module-vts

make

if [ "$?" -ne 0 ]; then
    exit 1;
fi

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
