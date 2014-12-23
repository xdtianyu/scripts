#!/bin/bash
read -d " " ip <<< $SSH_CONNECTION
#date=$(date "+%d.%m.%Y %Hh%M")
#reverse=$(dig -x $ip +short)
geo=$(curl -s http://ip.xdty.org -X POST -d "geo=$ip")
if [ -z "$geo" ];then
    geo="unknown"
fi
ip="$ip($geo)"
curl -s https://www.xdty.org/mail.php -X POST -d "event=($USER) login from $ip&name=whatever&email=xxxxx@gmail.com" &
