#!/bin/bash
#title           :localrt.sh
#description     :add local route after vpn or usb wifi.
#author          :xdtianyu@gmail.com
#date            :20141029
#version         :1.0 final
#usage           :bash localrt.sh
#bash_version    :4.3.11(1)-release
#==============================================================================

route add -net 192.168.160.0 netmask 255.255.255.0 gw 192.168.163.1
route add -net 192.168.161.0 netmask 255.255.255.0 gw 192.168.163.1
route add -net 192.168.162.0 netmask 255.255.255.0 gw 192.168.163.1
route add -net 192.168.163.0 netmask 255.255.255.0 gw 192.168.163.1
