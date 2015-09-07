#!/bin/bash

EMAIL="YOUR_EMAIL@example.com"
TIMEOUT=15
NAME="speedtest"
EVENT="finished"
OUTPUT=/tmp/wget.speedtest
SPEED_URL=https://example.com/speed.php
MAIL_URL=https://example.com/mail_extra.php

TEST_FILES=(
    https://node1.example.com/10meg.test
    https://node2.example.com/10meg.test
    https://node3.example.com/10meg.test
    https://node4.example.com/10meg.test
    https://node5.example.com/10meg.test
)

# speed test
if [ -f $OUTPUT ]; then
    rm $OUTPUT
fi

for file in ${TEST_FILES[@]}; do
    timeout $TIMEOUT wget -4 -O /dev/null $file -a $OUTPUT --progress=dot:binary
    echo -e "\n\n#######################\n" >>$OUTPUT
done

# send email

echo -e "Generate chart... \n"
curl -s --http1.0 $SPEED_URL -X POST -d "time=$TIMEOUT&client=$CLIENT" --data-urlencode extra@$OUTPUT --capath /etc/ssl/certs/

echo -e "Send email... \n"
curl -s --http1.0 $MAIL_URL -X POST -d "event=$EVENT&name=$NAME&email=$EMAIL" --data-urlencode extra@$OUTPUT --capath /etc/ssl/certs/

