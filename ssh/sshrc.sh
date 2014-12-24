#!/bin/bash
 
NAME="xxx"
EMAIL="xxx@gmail.com"
 
read -d " " ip <<< $PAM_RHOST
geo=$(curl -s http://ip.xdty.org -X POST -d "geo=$ip")
if [ -z "$geo" ];then
    geo="unknown"
fi
ip="$ip($geo)"
 
if [ $PAM_TYPE = "close_session" ];then
    EVENT="logout"
elif [ $PAM_TYPE = "open_session" ];then
    EVENT="login"
fi
 
curl -s https://www.xdty.org/mail.php -X POST -d "event=($PAM_USER) $EVENT from $ip&name=$NAME&email=$EMAIL" &
