#!/bin/bash
# crontab: */1 * * * * /root/bin/cm_monitor.sh >> /tmp/cm_monitor.log 2>&1

if [ $(ps -ef|grep cm.py|grep -v grep|wc -l) -eq 0 ]; then
    echo "$(date) -- cm.py is down, start again."
    screen -dmS cm python3 /root/cm/cm.py
else
  echo "$(date) -- cm.py is running."
fi
