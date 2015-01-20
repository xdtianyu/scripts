#!/bin/bash
#title           :mail.sh [event] [service name] [config file] 
#description     :This script will call mail api to send mail via gmail.
#author          :xdtianyu@gmail.com
#date            :20141201
#version         :2.0 final
#usage           :bash mail.sh
#bash_version    :4.3.11(1)-release

OUTPUT=/tmp/gdb.output

if [ $# -ne 3 ];then
	echo "Error param.";
	echo "Usage: $0 [event] [service name] [config file]"
	exit 0;
fi
 
EVENT=$1
NAME=$2
CONF=$(cat $3)

#bash /etc/opensips/gdb.sh
for file in $(find /tmp -maxdepth 1 -name core.*);do
    #echo $file;
    gdb -batch -ex "set logging file $file.trace" -ex "set logging on" -ex "set pagination off" -ex "bt full" -ex quit "opensips" "$file" > /dev/null 2>&1
    if [ ! -d "/tmp/opensips_coredump" ];then
        mkdir /tmp/opensips_coredump
    fi
    mv $file /tmp/opensips_coredump
done

for file in $(find /tmp -maxdepth 1 -name *.trace);do
    echo -e "##########  "$file"  ##########\n\n" >> $OUTPUT
    cat $file >> $OUTPUT
    echo -e "\n\n" >> $OUTPUT
    rm -f $file
done

if [ "$(echo $CONF|grep email|wc -l)" == "1" ];then
	curl -s --http1.0 https://www.xdty.org/mail_extra.php -X POST -d "event=$EVENT&name=$NAME&email=$(echo $CONF|grep email|cut -c7-)" --data-urlencode extra@$OUTPUT
else
	echo "Config file error."
fi

if [ -f "$OUTPUT" ];then
    rm -f $OUTPUT
fi
