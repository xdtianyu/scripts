#!/bin/bash
#==============================================================================

check_sub(){
    SAVEIFS=$IFS # setup this case the space char in file name.
    IFS=$(echo -en "\n\b")
	for subdir in $(find -maxdepth 1 -type d |grep ./ |cut -c 3-); 
        do 
            echo $subdir
            tar cf "$subdir.tar" "$subdir"
    done
    IFS=$SAVEIFS
}
check_sub
