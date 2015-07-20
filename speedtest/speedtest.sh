#!/bin/bash

EMAIL="YOUR_EMAIL@example.com"
TIMEOUT=20
NAME="speedtest"
EVENT="finished"
OUTPUT=/tmp/wget.speedtest

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
    timeout $TIMEOUT wget -4 -O /dev/null $file -a $OUTPUT
    echo -e "\n\n#######################\n" >>$OUTPUT
done

# send email
curl -s --http1.0 https://www.xdty.org/mail_extra.php -X POST -d "event=$EVENT&name=$NAME&email=$EMAIL" --data-urlencode extra@$OUTPUT --capath /etc/ssl/certs/
