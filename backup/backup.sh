#!/bin/bash

ALL=$1

TIME=$(date +%F-%H-%M-%S)
PASSWD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w30 | head -n1)

CONF_FILE="$(dirname $0)/backup.conf"

if [ -f "$CONF_FILE" ];then
    source "$CONF_FILE"
else
    echo "$CONF_FILE not exist."
    exit -1
fi

if [ ! -d "$TARGET_DIR" ]; then
    echo "Error, directory $TARGET_DIR not found." | tee -a "$LOG_FILE"
    exit -1
fi

ZIP="zip -P $PASSWD"

if [ "$ZIP_COMPRESS" != true ];then
    ZIP="zip -0 -P $PASSWD"
fi

# create tmp dir for archive files and dirs

cd /opt

if [ -d 'tmp' ]; then
    rm -r tmp
fi

mkdir tmp
cd tmp

# remove old backup files

if [ ! $(find "$TARGET_DIR" -name \*.zip |wc -l) == 0 ]; then
    rm "$TARGET_DIR"/*.zip
fi

# backup files

if [ -f "$TARGET_DIR/backup_files.zip" ]; then
    rm "$TARGET_DIR/backup_files.zip"
fi

echo "$(date) --> backup files: ${FILES[@]}" | tee -a "$LOG_FILE"
$ZIP "backup_files.zip" "${FILES[@]}"
mv "backup_files.zip" "$TARGET_DIR/backup-$TIME-backup_files.zip"

# backup dirs

for dir in "${DIRS[@]}"
do
    target="${dir//\//_}"
    target="${target:1}"

    if [ -f "$TARGET_DIR/$target.zip" ]; then
        rm "$TARGET_DIR/$target.zip"
    fi

    if [ -d "$dir" ]; then
        echo "$(date) --> backup: $dir" | tee -a "$LOG_FILE"
        if [ "$ALL" = "all" ] || [ ! -f "$dir/exclude.lst" ]; then
            $ZIP -r --symlinks "$target.zip" "$dir"
        else
            $ZIP -r --symlinks "$target.zip" "$dir" -x@"$dir/exclude.lst"
        fi
        mv "$target.zip" "$TARGET_DIR/backup-$TIME-$target.zip"
    else 
        echo "$(date) --> $dir not exist." | tee -a "$LOG_FILE"
    fi
done

# backup mysql

if [ "$BACKUP_MYSQL" == "true" ]; then

    echo "$(date) --> backup: mysql" | tee -a "$LOG_FILE"

    mysqldump --all-databases > mysql.sql
    $ZIP mysql.zip mysql.sql
    rm mysql.sql

    mv "mysql.zip" "$TARGET_DIR/backup-$TIME-mysql.zip"
fi

# clean tmp dir

cd /opt
rm -r tmp

#cp /root/Dropbox/*.zip /home/box/backup

# curl -s https://www.xdty.org/mail.php -X POST -d "event=$EVENT ($TIME|$PASSWD)&name=$NAME&email=$EMAIL" &

# echo $PASSWD

# send email

if [ "$ALL" = "all" ]; then
    EVENT="$EVENT(all)"
fi

sendemail -f "${SENDER%@*} <$SENDER>" \
    -u "$EVENT event notify" \
    -t "$EMAIL" \
    -s "$SMTP_SERVER" \
    -o tls=yes \
    -xu "$SENDER" \
    -xp "$SENDER_PASSWD" \
    -m "$EVENT completed ($TIME|$PASSWD) at $(date +'%Y-%m-%d %H:%M:%S')"
