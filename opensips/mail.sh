#!/bin/bash
#title           :mail.sh [event] [service name] [config file]
#description     :This script will call mail api to send mail via gmail.
#author          :xdtianyu@gmail.com
#date            :20141120
#version         :1.0 final
#usage           :bash mail.sh
#bash_version    :4.3.11(1)-release

if [ $# -ne 3 ];then
        echo "Error param.";
        echo "Usage: $0 [event] [service name] [config file]"
        exit 0;
fi

EVENT=$1
NAME=$2
CONF=$(cat $3)

if [ "$(echo $CONF|grep email|wc -l)" == "1" ];then
        curl -s https://www.xdty.org/mail.php -X POST -d "event=$EVENT&name=$NAME&email=$(echo $CONF|grep email|cut -c7-)"
else
        echo "Config file error."
fi
