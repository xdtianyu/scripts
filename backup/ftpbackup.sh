#!/bin/bash

SERVER="dedibackup-dc2.online.net"

LIST_FILE="/root/bin/ftpbackup.list"
LOG_FILE="/var/log/ftpbackup.log"
BACKUP_DIR="/home/backups"

USER="auto"
PASS=""

if [ -f "$LIST_FILE" ];then
    source "$LIST_FILE"
else
    echo "file list not exist."
    exit -1
fi

if [ ! -d "$BACKUP_DIR" ];then
    mkdir "$BACKUP_DIR"
fi

#for file in "${files[@]}"
#do
#    if [[ "$file" == *.img ]];then
#        echo "$(date) --> shrink: $file" >> "$LOG_FILE"
#        qemu-img convert -O qcow2 "$file" "$file.qcow2"
#    fi
#done

for dir in "${dirs[@]}"
do
    if [ -f "$BACKUP_DIR/$dir.tar.gz" ];then
        rm "$BACKUP_DIR/$dir.tar.gz"
    fi

    tar czf "$BACKUP_DIR/$dir.tar.gz" -C / "$dir"
done

ftp_mkdir() {
    local r
    local a
    r="$@"
    while [[ "$r" != "$a" ]] ; do
        a=${r%%/*}
        if [ -n "$a" ];then
            echo "mkdir $a"
            echo "cd $a"
        fi
        r=${r#*/}
    done
}

ftp_put() {
    echo "cd /"
    ftp_mkdir "$BACKUP_DIR"
    echo "lcd $BACKUP_DIR"
    for dir in "${dirs[@]}"
    do
        echo "$(date) --> backup: $dir" >> "$LOG_FILE"
        echo "put $dir.tar.gz"
    done

    for file in "${files[@]}"
    do
        echo "$(date) --> backup: $file" >> "$LOG_FILE"
        LCD="$(dirname $file)"
        FILE="$(basename $file)"
        echo "cd /"
        ftp_mkdir "$LCD"
        echo "lcd $LCD"
#        if [[ "$file" == *.img ]];then
#            echo "put $FILE.qcow2"
#        else
            echo "put $FILE"
#        fi
    done
}

ftp -p -n $SERVER <<END_FTP
quote user "$USER"
quote pass "$PASS"
binary
$(ftp_put)
quit
END_FTP

echo "$(date) --> done"

