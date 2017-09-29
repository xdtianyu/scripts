#!/usr/bin/env sh

CONFIG=$1

if [ ! -f "$CONFIG" ];then
    echo "ERROR, CONFIG NOT EXIST."
    exit 1
fi

# shellcheck source=/dev/null
. "$CONFIG"

if [ -f "$LAST_IP_FILE" ];then
    # shellcheck source=/dev/null
    . "$LAST_IP_FILE"
fi

IP=""
RETRY="0"
while [ $RETRY -lt 5 ]; do
    IP=$(curl -s ip.xdty.org)
    RETRY=$((RETRY+1))
    if [ -z "$IP" ];then
        sleep 3
    else
        break
    fi
done

if [ "$IP" = "$LAST_IP" ];then
    echo "$(date) -- Already updated."
    exit 0
fi

# Optional Parameter
#EXTERNAL_IP=$(curl -s https://api.ipify.org)
EXTERNAL_IP="$IP"

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
    -X GET "https://api.cloudflare.com/client/v4/zones?name=${CF_ZONE_NAME}" \
    -H "X-Auth-Email: ${CF_EMAIL}" \
    -H "X-Auth-Key: ${CF_TOKEN}" \
    -H "Content-Type: application/json"| \
    jsonValue id 1)
}

getDomainID() {
  CF_DOMAIN_ID=$(curl -s \
    -X GET "https://api.cloudflare.com/client/v4/zones/${CF_ZONE_ID}/dns_records?name=${CF_DOMAIN_NAME}" \
    -H "X-Auth-Email: ${CF_EMAIL}" \
    -H "X-Auth-Key: ${CF_TOKEN}" \
    -H "Content-Type: application/json" | \
    jsonValue id 1)
}

updateDomain() {
  RESULT=$(curl -s \
    -X PUT "https://api.cloudflare.com/client/v4/zones/${CF_ZONE_ID}/dns_records/${CF_DOMAIN_ID}" \
    -H "X-Auth-Email: ${CF_EMAIL}" \
    -H "X-Auth-Key: ${CF_TOKEN}" \
    -H "Content-Type: application/json" \
    --data '{"type":"A","name":"'"${CF_DOMAIN_NAME}"'","content":"'"${EXTERNAL_IP}"'","ttl":1,"proxied":false}' | \
    jsonValue success 1)

    if [ "$RESULT" = "true" ];then
        echo "$(date) -- Update success"
        echo "LAST_IP=\"$IP\"" > "$LAST_IP_FILE"
    else
        echo "$(date) -- Update failed"
    fi

}

getZoneID
getDomainID
updateDomain
