#!/bin/bash
#title           :newuser.sh
#description     :create users for freeswitch.
#author          :xdtianyu@gmail.com
#date            :20141029
#version         :1.0 final
#usage           :bash newuser.sh user_number_start user_number_end (bash newuser.sh 10000 20000)
#bash_version    :4.3.11(1)-release
#==============================================================================
XML='<include>\n
  <user id="1000">\n
    <params>\n
      <param name="password" value="$${default_password}"/>\n
      <param name="vm-password" value="1000"/>\n
    </params>\n
    <variables>\n
      <variable name="toll_allow" value="domestic,international,local"/>\n
      <variable name="accountcode" value="1000"/>\n
      <variable name="user_context" value="default"/>\n
      <variable name="effective_caller_id_name" value="Extension 1000"/>\n
      <variable name="effective_caller_id_number" value="1000"/>\n
      <variable name="outbound_caller_id_name" value="$${outbound_caller_name}"/>\n
      <variable name="outbound_caller_id_number" value="$${outbound_caller_id}"/>\n
      <variable name="callgroup" value="techsupport"/>\n
    </variables>\n
  </user>\n
</include>'

mkdir xml

for (( i = $1; i <= $2 ; i ++ ))
do
    echo -e ${XML//1000/$i} >xml/$i.xml
done


