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

if [ $UID -ne 0 ]; then
    echo "Superuser privileges are required to run this script."
    echo "e.g. \"sudo ./$RELEASEBIN\""
    exit 0
fi

if [ ! -z "$1" ];then
	if [ $1 = "install" ];then
		echo "Install opensips..."
	elif [ $1 = "uninstall" ];then
		echo "Uninstall opensips..."
		for file in $SBINS;do
			if [ -f "/$BINDIR/$file" ];then
				echo "uninstall /$BINDIR/$file"
				rm -f /$BINDIR/$file
			fi
		done
		if [ -d "/$LIBDIR/$BINNAME" ];then
			echo "removing /$LIBDIR/$BINNAME"
			rm -rf /$LIBDIR/$BINNAME
		fi
		echo "Uninstall completed."
		exit 0
	elif [ $1 = "purge" ];then
		echo "Purge opensips..."
		for file in $SBINS;do
                        if [ -f "/$BINDIR/$file" ];then
                                echo "purge /$BINDIR/$file"
                                rm -f /$BINDIR/$file
                        fi
                done
                if [ -d "/$LIBDIR/$BINNAME" ];then
                        echo "purge /$LIBDIR/$BINNAME"
                        rm -rf /$LIBDIR/$BINNAME
                fi
		if [ -d "/$ETCDIR/$BINNAME" ];then
			echo "purge /$ETCDIR/$BINNAME"
			rm -rf /$ETCDIR/$BINNAME
		fi
		echo "Purge completed."
		exit 0
	else
		echo "Unknow param, exit."
		exit 0
	fi
else
	echo "Install opensips..."
fi

echo -e "Checking for a supported OS... \c"

FAIL="true"
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
	
	# disable os check.
	if [ ! "$FAIL" = "false" ];then
		echo "OK"
		FAIL="false"
	fi

	
	if [ ! "$FAIL" = "false" ];then
		echo "This file can only installed on $(cat os), abort."
		FAIL="true"
	fi
fi

if [ ! $FAIL = "true" ]; then

echo -e "Checking for a 64-bit OS... \c"

if [ $(uname -i) = $(cat hardware) ];then
	echo "OK"
	FAIL="false"
else
	echo "This file can only installed on $(cat hardware) hardware platform, abort."
	FAIL="true"
fi

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
    echo "install $BINNAME.default to /$ETCDIR/default/$BINNAME..."
    cp $ETCDIR/default/$BINNAME.default /$ETCDIR/default/$BINNAME
    echo "install $BINNAME.init to /$ETCDIR/init.d/$BINNAME..."
    cp $ETCDIR/init.d/$BINNAME.init /$ETCDIR/init.d/$BINNAME
    chmod +x /$ETCDIR/init.d/$BINNAME
    if [ -n $(command -v apt-get) ]; then
        bash $ETCDIR/$BINNAME.postinst configure
    elif [ -n $(command -v yum) ]; then
        bash $ETCDIR/$BINNAME.postinst configure
        passwd -l opensips
    fi
fi
cp -r $ETCDIR/$BINNAME /$ETCDIR

if [ -d "/$LIBDIR/$BINNAME" ];then
	echo "/$LIBDIR/$BINNAME already exist, make backup."
	mv /$LIBDIR/$BINNAME /$LIBDIR/$BINNAME.backup-$(date +%F-%H-%M-%S)
fi

cp -r $LIBDIR/$BINNAME /$LIBDIR/$BINNAME

echo "Done. Please edit necessary configures to run opensips."
