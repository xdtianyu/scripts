#!/bin/sh

CONFIG=$1
DOMAIN_FULL=$2
TXT_TOKEN=$3

if [ ! -f "$CONFIG" ];then
    echo "ERROR, CONFIG NOT EXIST."
    exit 1
fi 

. "$CONFIG"

SUB_DOMAIN=${DOMAIN_FULL%$DOMAIN}

if [ -z "$SUB_DOMAIN" ];then
    HOST="_acme-challenge"
else
    HOST="_acme-challenge.${SUB_DOMAIN%.}"
fi 

echo "$HOST.$DOMAIN"

OPTIONS="login_token=${TOKEN}";
OUT=$(curl -s -k "https://dnsapi.cn/Domain.List" -d "${OPTIONS}");
for line in $OUT;do
    if [ "$(echo "$line"|grep '<id>' -c)" != 0 ];then
        DOMAIN_ID=${line%<*};
        DOMAIN_ID=${DOMAIN_ID#*>};
        # echo "domain id: $DOMAIN_ID";
    fi
    if [ "$(echo "$line"|grep '<name>' -c)" != 0 ];then
        DOMAIN_NAME=${line%<*};
        DOMAIN_NAME=${DOMAIN_NAME#*>};
        # echo "domain name: $DOMAIN_NAME";
        if [ "$DOMAIN_NAME" = "$DOMAIN" ];then
           break;
        fi
    fi
done

echo "$DOMAIN_NAME $DOMAIN_ID"

OUT=$(curl -s -k "https://dnsapi.cn/Record.List" -d "${OPTIONS}&domain_id=${DOMAIN_ID}")
for line in $OUT;do
    if [ "$(echo "$line"|grep '<id>' -c)" != 0 ];then
        RECORD_ID=${line%<*};
        RECORD_ID=${RECORD_ID#*>};
        # echo "record id: $RECORD_ID";
    fi
    if [ "$(echo "$line"|grep '<name>' -c)" != 0 ];then
        RECORD_NAME=${line%<*};
        RECORD_NAME=${RECORD_NAME#*>};
        # echo "record name: $RECORD_NAME";
        if [ "$RECORD_NAME" = "$HOST" ];then
           break;
        fi
    fi
done
echo "$RECORD_NAME:$RECORD_ID"

if [ "$RECORD_NAME" = "$HOST" ];then
    echo "UPDATE RECORD"
    OUT=$(curl -k -s "https://dnsapi.cn/Record.Modify" -d "${OPTIONS}&domain_id=${DOMAIN_ID}&record_id=${RECORD_ID}&sub_domain=${HOST}&record_line=${RECORD_LINE}&record_type=TXT&value=${TXT_TOKEN}")
else
    echo "NEW RECORD"
    OUT=$(curl -k -s "https://dnsapi.cn/Record.Create" -d "${OPTIONS}&domain_id=${DOMAIN_ID}&sub_domain=${HOST}&record_line=${RECORD_LINE}&record_type=TXT&value=${TXT_TOKEN}")
fi

if [ "$(echo "$OUT"|grep 'successful' -c)" != 0 ];then
    echo "DNS UPDATE SUCCESS"
else
    echo "DNS UPDATE FAILED"
fi
