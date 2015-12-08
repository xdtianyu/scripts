#!/bin/bash

# Usage: /etc/nginx/certs/letsencrypt.sh /etc/nginx/certs/letsencrypt.conf

CONFIG=$1
ACME_TINY="/tmp/acme_tiny.py"

if [ -f "$CONFIG" ];then
    . $CONFIG
    cd $(dirname $CONFIG)
else
    echo "ERROR CONFIG."
    exit 1
fi

KEY_PREFIX="${DOMAIN_KEY%%.*}"
DOMAIN_CRT="$KEY_PREFIX.crt"
DOMAIN_CSR="$KEY_PREFIX.csr"
DOMAIN_CHAINED_CRT="$KEY_PREFIX.chained.crt"

if [ ! -f "$ACCOUNT_KEY" ];then
    echo "Generate account key..."
    openssl genrsa 4096 > $ACCOUNT_KEY
fi

if [ ! -f "$DOMAIN_KEY" ];then
    echo "Generate domain key..."
    openssl genrsa 2048 > $DOMAIN_KEY
fi

echo "Generate CSR...$DOAMIN_CSR"

OPENSSL_CONF="/etc/ssl/openssl.cnf"

if [ ! -f "$OPENSSL_CONF" ];then
    OPENSSL_CONF="/etc/pki/tls/openssl.cnf"
    if [ ! -f "$OPENSSL_CONF" ];then
        echo "Error, file openssl.cnf not found."
        exit 1
    fi
fi

openssl req -new -sha256 -key $DOMAIN_KEY -subj "/" -reqexts SAN -config <(cat $OPENSSL_CONF <(printf "[SAN]\nsubjectAltName=$DOMAINS")) > $DOMAIN_CSR

wget https://raw.githubusercontent.com/diafygi/acme-tiny/master/acme_tiny.py -O $ACME_TINY -o /dev/null

if [ -f "$DOMAIN_CRT" ];then
    mv $DOMAIN_CRT $DOMAIN_CRT-OLD-$(date +%y%m%d-%H%M%S)
fi

DOMAIN_DIR="$DOMAIN_DIR/.well-known/acme-challenge/"
mkdir -p $DOMAIN_DIR

python $ACME_TINY --account-key $ACCOUNT_KEY --csr $DOMAIN_CSR --acme-dir $DOMAIN_DIR > $DOMAIN_CRT

if [ "$?" != 0 ];then
    exit 1
fi

if [ ! -f "lets-encrypt-x1-cross-signed.pem" ];then
    wget https://letsencrypt.org/certs/lets-encrypt-x1-cross-signed.pem -o /dev/null
fi

cat $DOMAIN_CRT lets-encrypt-x1-cross-signed.pem > $DOMAIN_CHAINED_CRT


echo -e "\e[01;32mNew cert: $DOMAIN_CHAINED_CRT has been generated\e[0m"

#service nginx reload
