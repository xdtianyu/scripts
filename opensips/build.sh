#!/bin/bash
#title           :build.sh
#description     :This script will build a release(opensips.run) file of opensips
#author          :xdtianyu@gmail.com
#date            :20141105
#version         :1.0 final
#usage           :sudo ./build.sh to build the opensips.run, sudo ./build.sh -c to clean release.
#bash_version    :4.3.11(1)-release
#==============================================================================

BINDIR="archive/sbin"
ETCDIR="archive/etc"
LIBDIR="archive/lib64"
SBINS="opensipsctl opensipsunix osipsconfig opensips opensipsdbctl osipsconsole"
BINNAME="opensips"
RELEASEBIN="opensips.run"
RUNSCRIPT="install.sh"

if [ $UID -ne 0 ]; then
    echo "Superuser privileges are required to run this script."
    echo "e.g. \"sudo $0\""
    exit 0
fi

if [ ! -z $1 ]; then
	if [ $1 = "-c" ]; then
		echo "cleaning build..."
		if [ -d "archive" ]; then
			rm -rf archive
		fi
		if [ -d "release" ]; then
			rm -rf release
		fi
		exit 0
	else 
		echo "unknow param: $1"
		exit 0
	fi
fi

echo "Build opensips installer..."
if [ ! -d "archive" ];
then
	echo "create directory archive..."
else
	echo "recreate directory archive..."
	rm -rf archive
fi

mkdir -p $BINDIR $ETCDIR $LIBDIR

for bins in $SBINS;
do 
	if [ ! -f "/sbin/$bins" ];
	then 
		echo "/sbin/$bins not exist, stop now."
		exit 0
	else
		echo "copying /sbin/$bins..."
		cp /sbin/$bins $BINDIR
	fi 
done

if [ ! -d "/etc/$BINNAME" ];then
	echo "/etc/$BINNAME not exist, stop now."
	exit 0
else
	echo "copying /etc/$BINNAME..."
	cp -r /etc/$BINNAME $ETCDIR
fi

if [ ! -d "/lib64/$BINNAME" ];then
	echo "/lib64/$BINNAME not exist, stop now."
	exit 0
else
	echo "copying /lib64/$BINNAME..."
	cp -r /lib64/$BINNAME $LIBDIR
fi

echo -e $(cat /etc/issue |head -n1)|head -n1 >archive/os
if [ -f "/etc/redhat-release" ];then
	echo -e $(cat /etc/redhat-release |head -n1)|head -n1 >archive/os
fi
	
uname -i > archive/hardware

cp $RUNSCRIPT archive
./makeself.sh archive/ $RELEASEBIN "$RELEASEBIN" ./$RUNSCRIPT 
rm -rf archive

if [ -f "$RELEASEBIN" ]; then
	if [ -d "release" ]; then
		rm -rf release
	fi
	mkdir release
	mv $RELEASEBIN release
	echo "Done. Please check file release/$RELEASEBIN"
else
	echo "Error detected."
fi
