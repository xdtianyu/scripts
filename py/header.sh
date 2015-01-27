#!/bin/bash
#'''
#    File name: header.sh
#    Author: xdtianyu@gmail.com
#    Date created: 2015-01-07 14:24:16
#    Date last modified: 2015-01-09 15:19:31
#    Bash Version: 4.3.11(1)-release
#'''
 
AUTHOR="xdtianyu@gmail.com"
PYTHON_VERSION=$(python -c 'import sys; print(sys.version[:5])')
 
for file in $(ls *.py); do
    echo "check $file ..."
    MODIFIED=$(stat -c %y $file| cut -d'.' -f1)
    #echo "Last modified: $MODIFIED"
    CURRENT_DATE=$(date "+%Y-%m-%d %H:%M:%S")
    AUTHOR_COUNT=$(cat "$file" |grep "    Author:" |wc -l)
    if [ $AUTHOR_COUNT  -gt 1 ];then
        echo "More than one author, skip."
        continue
    elif [ $AUTHOR_COUNT -eq 1 ];then
        echo "Have author, check modified date."
        ORI=$(cat $file |grep "    Date last modified: ")
        if [ "$ORI" == "" ];then
            echo "no line"
            continue
        fi
        TARGET="    Date last modified: ${MODIFIED}"
        #echo $ORI
        #echo $TARGET
        if [ "$ORI" == "$TARGET" ];then
            echo "No change detected."
        else
            if [ $(cat $file |grep "    Date last modified: "|wc -l) -gt 1 ];then
                echo "More than one \"Date last modified\" detected, skip"
                continue
            fi
            LINE=$(cat $file |grep "    Date last modified: " -n | cut -d':' -f1)
            sed -i "${LINE}s/.*/    Date last modified: ${CURRENT_DATE}/" $file
        fi
        # Check file name
        FILE_COUNT=$(cat $file |grep "    File name:"|wc -l)
        if [ $FILE_COUNT -gt 1 ];then
            echo "More than one \"File name\" detecetd, skip"
            continue
        elif [ $FILE_COUNT -eq 1 ];then
            echo "Check file name..."
            ORI_FILE_NAME=$(cat $file |grep "    File name:")
            TARGET_FILE_NAME="    File name: $file"
            if [ ! "$ORI_FILE_NAME" == "$TARGET_FILE_NAME" ];then
                echo "File name changed, update now"
                FILE_LINE=$(cat $file |grep "    File name: " -n | cut -d':' -f1)
                sed -i "${FILE_LINE}s/.*/${TARGET_FILE_NAME}/" $file
            else
                echo "No change detected."
            fi
        fi
    else
        echo "Have no author, add header."
        sed -i "1s/^/\'\'\'\n    File name: $file\n    Author: $AUTHOR\n    Date created: $MODIFIED\n    Date last modified: $CURRENT_DATE\n    Python Version: $PYTHON_VERSION\n\'\'\'\n\n/" $file
    fi
done
