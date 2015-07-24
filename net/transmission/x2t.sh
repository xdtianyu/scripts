#!/bin/bash

USER="HTTP_USER"
PASSWORD="HTTP_PASSOWRD"
RPC="https://home.example.com/jsonrpc"
TOKEN="ARIA2_TOKEN"

DOWNLOAD_URLS=(
    https://remote.example.com/downloads/
    https://cdn1.example.com/downloads/
    https://cdn2.example.com/downloads/
    https://cdn3.example.com/downloads/
    https://cdn4.example.com/downloads/
)


check_sub(){
	echo "check sub."
    SAVEIFS=$IFS # setup this case the space char in file name.
    IFS=$(echo -en "\n\b")
	for subdir in $(find -maxdepth 1 -type d |grep ./ |cut -c 3-); 
        do 
            echo $subdir
            cd "$subdir"
            convert_to_jpg
            cd ..
    done
    IFS=$SAVEIFS
}

convert_to_jpg(){
    
    for ext in jpg JPG bmp BMP png PNG; do
        echo "ext is $ext"
        if [ ! $(find . -maxdepth 1 -name \*.$ext | wc -l) = 0 ]; 
	    then 
		    x2jpg $ext
	    fi
    done

    check_sub # check if has sub directory.
}

x2jpg(){
    if [ ! -d origin ];then
	mkdir origin
    fi
    if [ ! -d /tmp/jpg ]; then

	    mkdir /tmp/jpg
    fi

    tmp_fifofile="/tmp/$$.fifo"
    mkfifo $tmp_fifofile      # create a fifo type file.
    exec 6<>$tmp_fifofile      # point fd6 to fifo file.
    rm $tmp_fifofile


    thread=10 # define numbers of threads.
    for ((i=0;i<$thread;i++));do 
    echo
    done >&6 # actually only put $thread RETURNs to fd6.

    for file in ./*.$1;do
    read -u6 
    {
        echo 'convert -quality 80' "$file" /tmp/jpg/"${file%.*}"'.jpg'
        convert -limit memory 64 -limit map 128 -quality 80 "$file" /tmp/jpg/"${file%.*}".jpg
        mv "$file" origin
        echo >&6
    } &
    done

    wait # wait for all child thread end.
    exec 6>&- # close fd6

    mv /tmp/jpg/* .
    rm -r origin

    echo 'DONE!'
}

TYPE=$1
file=$2

tmpdir=$(mktemp -d)

if [ "$TYPE"="-z" ]; then
    DIR="${file%%.zip*}"
    echo "unzip $file -d $tmpdir";
    unzip "$file" -d $tmpdir # unzip to a tmp directory.
elif [ "$TYPE"="-r" ]; then
    DIR="${file%%.rar*}"
    echo "unrar x $file $tmpdir";
    mv "$file" tmp.rar
    unrar x tmp.rar $tmpdir # unrar to a tmp directory.
    mv tmp.rar "$file"
fi

if [ $(ls $tmpdir | wc -l) = 1 ]; then # check if has folders, and mv the unziped directory as same name with the zip file.
    DIR2=$(ls $tmpdir)
    mv "$tmpdir/$DIR2" "$DIR"
    rmdir $tmpdir
else
    mv $tmpdir "$DIR"
fi	

echo $DIR
if [ -d "$DIR" ]; then
    cd "$DIR"
    convert_to_jpg # convert process.
    cd ..
    echo "tar cvf $DIR.tar $DIR" 
    tar cvf "$DIR.tar" "$DIR" --force-local # tar the directory.
    rm -r "$DIR"
    LINK=""
    for URL in "${DOWNLOAD_URLS[@]}"; do
        if [ -z "$LINK" ]; then
            LINK="\"$URL$DIR.tar\""
        else
            LINK="$LINK, \"$URL$DIR.tar\""
        fi
    done
    curl -s -v --user $USER:$PASSWORD $RPC -X POST -d "[{\"jsonrpc\":\"2.0\",\"method\":\"aria2.addUri\",\"id\":1,\"params\":[\"token:$TOKEN\",[$LINK],{\"split\":\"10\",\"max-connection-per-server\":\"10\",\"seed-ratio\":\"1.0\"}]}]"
else
    echo "$DIR not exist."
fi
