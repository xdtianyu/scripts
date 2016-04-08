#!/bin/bash

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

URL_D="https://www.cloudxns.net/api2/domain"
DATE=$(date)
HMAC_D=$(echo -n "$API_KEY$URL_D$DATE$SECRET_KEY"|md5sum|cut -d" " -f1)
DOMAIN_ID=$(curl -k -s $URL_D -H "API-KEY: $API_KEY" -H "API-REQUEST-DATE: $DATE" -H "API-HMAC: $HMAC_D"|grep -o "id\":\"[0-9]*\",\"domain\":\"$DOMAIN"|grep -o "[0-9]*"|head -n1)

echo "DOMAIN ID: $DOMAIN_ID"

URL_R="https://www.cloudxns.net/api2/record/$DOMAIN_ID?host_id=0&row_num=500"
HMAC_R=$(echo -n "$API_KEY$URL_R$DATE$SECRET_KEY"|md5sum|cut -d" " -f1)
RECORD_ID=$(curl -k -s "$URL_R" -H "API-KEY: $API_KEY" -H "API-REQUEST-DATE: $DATE" -H "API-HMAC: $HMAC_R"|grep -o "record_id\":\"[0-9]*\",\"host_id\":\"[0-9]*\",\"host\":\"$HOST\""|grep -o "record_id\":\"[0-9]*"|grep -o "[0-9]*"|head -n1)

echo "RECORD ID: $RECORD_ID"

if [ -z "$RECORD_ID" ];then
    URL_U="https://www.cloudxns.net/api2/record"
    CURLX="POST"
else
    URL_U="https://www.cloudxns.net/api2/record/$RECORD_ID"
    CURLX="PUT"
fi

PARAM_BODY="{\"domain_id\":\"$DOMAIN_ID\",\"host\":\"$HOST\",\"value\":\"$TXT_TOKEN\",\"type\":\"TXT\",\"line_id\":1,\"ttl\":60}"
HMAC_U=$(echo -n "$API_KEY$URL_U$PARAM_BODY$DATE$SECRET_KEY"|md5sum|cut -d" " -f1)

RESULT=$(curl -k -s "$URL_U" -X "$CURLX" -d "$PARAM_BODY" -H "API-KEY: $API_KEY" -H "API-REQUEST-DATE: $DATE" -H "API-HMAC: $HMAC_U" -H 'Content-Type: application/json')

echo "$RESULT"

RES=$(echo -n "$RESULT"|grep -o "message\":\"success\"" -c)

if [ "$RES" = 1 ];then
    echo "$(date) -- Update success"
else
    echo "$(date) -- Update failed"
fi
