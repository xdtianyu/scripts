#!/bin/bash
#title           :install.sh
#description     :This script will be build in the release file
#author          :xdtianyu@gmail.com
#date            :20141105
#version         :1.0 final
#usage           :DO NOT RUN THIS FILE BY HAND.
#bash_version    :4.3.11(1)-release
#==============================================================================
BINDIR="sbin"
ETCDIR="etc"
LIBDIR="lib64"
SBINS="opensipsctl opensipsunix osipsconfig opensips opensipsdbctl osipsconsole"
BINNAME="opensips"
RELEASEBIN="opensips.run"

echo "Install opensips..."

if [ $UID -ne 0 ]; then
    echo "Superuser privileges are required to run this script."
    echo "e.g. \"sudo ./$RELEASEBIN\""
    exit 0
fi

echo -e "Checking for a supported OS... \c"

if [ "$(echo -e $(cat /etc/issue |head -n1)|head -n1)" = "$(cat os)" ];then
	echo "OK"
	FAIL="false"
else
	if [ -f "/etc/redhat-release" ];then
        	if [ "$(echo -e $(cat /etc/redhat-release |head -n1)|head -n1)" = "$(cat os)" ];then
        		echo "OK"
        		FAIL="false"
        	fi
	fi
	if [ ! $FAIL = "false" ];then
		echo "This file can only installed on $(cat os), abort."
		FAIL="true"
	fi
fi

echo -e "Checking for a 64-bit OS... \c"

if [ $(uname -i) = $(cat hardware) ];then
	echo "OK"
	FAIL="false"
else
	echo "This file can only installed on $(cat hardware) hardware platform, abort."
	FAIL="true"
fi

if [ $FAIL = "true" ];then
	echo "Aborting installation due to unsatisfied requirements."
	echo "Installation failed."	
	exit 0
fi

for file in $SBINS;do
	echo "install $file to /$BINDIR/ ..."
	if [ -f "/$BINDIR/$file" ];then
		rm -f /$BINDIR/$file
	fi
	cp $BINDIR/$file /$BINDIR/
done

if [ -d "/$ETCDIR/$BINNAME" ];then
	echo "/$ETCDIR/$BINNAME already exist, make backup."
	mv /$ETCDIR/$BINNAME /$ETCDIR/$BINNAME.backup-$(date +%F-%H-%M-%S)
fi
cp -r $ETCDIR/$BINNAME /$ETCDIR

if [ -d "/$LIBDIR/$BINNAME" ];then
	echo "/$LIBDIR/$BINNAME already exist, make backup."
	mv /$LIBDIR/$BINNAME /$LIBDIR/$BINNAME.backup-$(date +%F-%H-%M-%S)
fi

cp -r $LIBDIR/$BINNAME /$LIBDIR/$BINNAME

echo "Done. Please edit necessary configures to run opensips."
