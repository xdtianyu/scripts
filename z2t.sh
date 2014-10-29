#!/bin/bash
#title           :z2t.sh
#description     :This script will convert all zips(of jpg/bmp/png) with any content struct to tars(of jpg). Use "convert" command to convert images to jpg to depress disk space. the origin file's content struct will not change.
#author          :xdtianyu@gmail.com
#date            :20141029
#version         :1.0 final
#usage           :bash z2t
#bash_version    :4.3.11(1)-release
#==============================================================================

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
        convert -quality 80 "$file" /tmp/jpg/"${file%.*}".jpg
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


for file in *.zip ; do
	tmpdir=$(mktemp -d)
	DIR="${file%%.zip*}"
	echo "unzip $file -d $tmpdir";
	unzip "$file" -d $tmpdir # unzip to a tmp directory.
	
	if [ $(ls $tmpdir | wc -l) = 1 ]; then # check if has folders, and mv the unziped directory as same name with the zip file.
		DIR2=$(ls $tmpdir)
		mv "$tmpdir/$DIR2" "$DIR"
		rmdir $tmpdir
	else
		mv $tmpdir "$DIR"
	fi	

	echo $DIR
	if [ -d "$DIR" ];
	then
		cd "$DIR"
		convert_to_jpg # convert process.
        cd ..
        echo "tar cvf $DIR.tar $DIR" 
        tar cvf "$DIR.tar" "$DIR" # tar the directory.
		rm -r "$DIR"
	else
		echo "$DIR not exist."
	fi
done

if [ ! -d "tars" ]; then
    mkdir tars
fi

if [ ! $(find . -maxdepth 1 -name \*.tar | wc -l) = 0 ]; 
then 
	mv *.tar tars
fi

# check status.
for file in *.zip; do
    TAR="tars/${file%%.zip*}.tar"
    echo "check \"$TAR\" ..."
    if [ -f "$TAR" ];then
        echo "$file convert OK."
        cd tars
        md5sum "${file%%.zip*}.tar" > "${file%%.zip*}.md5" # generate md5 file.
        cd ..
    else
        echo "$file convert FAILED."
    fi
done
