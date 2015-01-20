#!/bin/bash
OUTPUT=/tmp/gdb.output

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
