#!/bin/bash
#title           :autobuild.sh
#description     :This script will auto build opensips and send email to receivers.
#author          :xdtianyu@gmail.com
#date            :20141205
#version         :1.0 final
#usage           :bash autobuild.sh
#bash_version    :4.3.11(1)-release

SUDO_PASSWORD="123456" # PLEASE MODIFY THIS
OUTPUT="/tmp/make.put"
ERROR_OUTPUT="/tmp/error.out"
OUTPUT_DATA="/tmp/output.data"
MAKE_SCRIPT="/home/builder/bin/make.sh"

EVENT="event"
NAME="auto build"
CONF="/home/builder/bin/mail.cfg"
PUSH_SERVER="sip.example.com" # PLEASE MODIFY THIS

SUCCESS_MESSAGE="Please check file: $PUSH_SERVER:/root/opensips.run ."

if [ -f "$OUTPUT" ];then
    echo $SUDO_PASSWORD|sudo -S rm -rf $"$OUTPUT"
fi

if [ -f "$ERROR_OUTPUT" ];then
    echo $SUDO_PASSWORD|sudo -S rm -rf $"$OUTPUT"
fi

if [ -f "$MAKE_SCRIPT" ];then
    start=$(date +%s)
    bash $MAKE_SCRIPT > $OUTPUT 2>&1
    stop=$(date +%s)
else
    echo "no $MAKE_SCRIPT find." >$ERROR_OUTPUT
fi

if [ -f "$ERROR_OUTPUT" ];then
    echo $SUDO_PASSWORD|sudo -S cat $ERROR_OUTPUT > $OUTPUT_DATA
else
    echo $SUDO_PASSWORD|sudo -S echo -e "build success (takes $[ stop - start ] seconds). \n$SUCCESS_MESSAGE" > $OUTPUT_DATA
fi

if [ -f "$OUTPUT" ];then
    echo $SUDO_PASSWORD|sudo -S echo -e "\n--- build log ------\n" >> $OUTPUT_DATA
    echo $SUDO_PASSWORD|sudo -S cat $OUTPUT >> $OUTPUT_DATA
fi

# MAY BE NEED AUTH KEY TO SEND EMAIL LATER
curl -s --http1.0 https://www.xdty.org/mail_extra.php -X POST -d "event=$EVENT&name=$NAME&email=$(cat $CONF|grep email|cut -c7-)" --data-urlencode extra@$OUTPUT_DATA
