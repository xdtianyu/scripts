#!/bin/bash

# dependencies: wireless-tools

DIR=$(dirname $0)

source "$DIR/wireless.conf"

WIFI=$(uci get wireless.@wifi-iface[0].ssid)

echo "$(date) current wifi: $WIFI"

if [ $(iw dev wlan0 scan|grep "$WIFI"|wc -l) -eq 0 ];then
    uci set wireless.@wifi-iface[0].disabled=1
    uci commit
    /etc/init.d/network restart
    sleep 15
fi


for wifi in "${essids[@]}" ; do
    ESSID="${wifi%%:*}"
    PASS="${wifi##*:}"
    echo "$(date) checking: $ESSID ..."
    #echo "$PASS"

    if [ $(iw dev wlan0 scan|grep "$ESSID"|wc -l) -ne 0 ];then
        echo "$(date) wifi: $ESSID is detected."

        if [ "$WIFI" != "$ESSID" ]; then
            uci set wireless.@wifi-device[0].channel="auto"
            uci set wireless.@wifi-iface[0].ssid="$ESSID"
            uci set wireless.@wifi-iface[0].key="$PASS"
            uci delete wireless.@wifi-iface[0].bssid
            uci set wireless.@wifi-iface[0].disabled=0
            if [ -z "$PASS" ]; then
                uci set wireless.@wifi-iface[0].encryption="none"
                uci delete wireless.@wifi-iface[0].key
            else
                uci set wireless.@wifi-iface[0].encryption="psk-mixed"
            fi
            uci commit
            /etc/init.d/network restart
            echo "$(date) wifi: $ESSID is updated."
        fi

        break
    fi
done
