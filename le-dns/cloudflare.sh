#!/usr/bin/env sh

CONFIG=$1
DOMAIN_FULL=$2
TXT_TOKEN=$3

if [ ! -f "$CONFIG" ];then
    echo "ERROR, CONFIG NOT EXIST."
    exit 1
fi

# shellcheck source=/dev/null
. "$CONFIG"

SUB_DOMAIN=${DOMAIN_FULL%$DOMAIN}

HOST="_acme-challenge.${DOMAIN_FULL}"

# we get them automatically for you
CF_ZONE_ID=""
CF_DOMAIN_ID=""

jsonValue() {
    KEY=$1
    num=$2
    awk -F"[,:}]" '{for(i=1;i<=NF;i++){if($i~/'"$KEY"'\042/){print $(i+1)}}}' | tr -d '"' | sed -n "${num}"p
}


getZoneID() {
  CF_ZONE_ID=$(curl -s \
    -X GET "https://api.cloudflare.com/client/v4/zones?name=${DOMAIN}" \
    -H "X-Auth-Email: ${CF_EMAIL}" \
    -H "X-Auth-Key: ${CF_TOKEN}" \
    -H "Content-Type: application/json"| \
    jsonValue id 1)
}

getDomainID() {
  CF_DOMAIN_ID=$(curl -s \
    -X GET "https://api.cloudflare.com/client/v4/zones/${CF_ZONE_ID}/dns_records?name=${HOST}" \
    -H "X-Auth-Email: ${CF_EMAIL}" \
    -H "X-Auth-Key: ${CF_TOKEN}" \
    -H "Content-Type: application/json" | \
    jsonValue id 1)
}

createDomain() {
  RESULT=$(curl -s \
    -X POST "https://api.cloudflare.com/client/v4/zones/${CF_ZONE_ID}/dns_records" \
    -H "X-Auth-Email: ${CF_EMAIL}" \
    -H "X-Auth-Key: ${CF_TOKEN}" \
    -H "Content-Type: application/json" \
    --data '{"type":"TXT","name":"'"${HOST}"'","content":"'"${TXT_TOKEN}"'","ttl":1,"proxied":false}' | \
    jsonValue success 1)

    if [ "$RESULT" = "true" ];then
        echo "$(date) -- Update success"
    else
        echo "$(date) -- Update failed"
    fi

}

updateDomain() {
  RESULT=$(curl -s \
    -X PUT "https://api.cloudflare.com/client/v4/zones/${CF_ZONE_ID}/dns_records/${CF_DOMAIN_ID}" \
    -H "X-Auth-Email: ${CF_EMAIL}" \
    -H "X-Auth-Key: ${CF_TOKEN}" \
    -H "Content-Type: application/json" \
    --data '{"type":"TXT","name":"'"${HOST}"'","content":"'"${TXT_TOKEN}"'","ttl":1,"proxied":false}' | \
    jsonValue success 1)

    if [ "$RESULT" = "true" ];then
        echo "$(date) -- Update success"
    else
        echo "$(date) -- Update failed"
    fi

}

getZoneID

if [ -z "$ALWAYS_CREATE_DOMAIN" ]; then
    getDomainID
fi

if [ -z "$CF_DOMAIN_ID" ];then
    createDomain
else
    updateDomain
fi

