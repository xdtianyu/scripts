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
BACKUP="no"
RELEASEDIR="release"

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
        if [ -n "$2" ] && [ "$2" = "--backup" ]; then
            echo "cleaning backup..."
            RELEASEDIR="backup"
        fi
		if [ -d "$RELEASEDIR" ]; then
			rm -rf $RELEASEDIR
		fi
		exit 0
    elif [ "$1" = "--backup" ]; then
        echo "create backup..."
        RELEASEBIN="opensips-backup-"$(date +%F-%H-%M-%S)".run"
        RELEASEDIR="backup"
        BACKUP="yes"
		if [ -d "archive" ]; then
			rm -rf archive
		fi
		if [ -d "$RELEASEDIR" ]; then
			rm -rf $RELEASEDIR
		fi
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
    
    mkdir $ETCDIR/default
    mkdir $ETCDIR/init.d
    if [ -n "$(command -v apt-get)" ]; then
        if [ "$BACKUP" = "no" ]; then
            echo "copying ../packaging/debian/$BINNAME.default ..."
            cp ../packaging/debian/$BINNAME.default $ETCDIR/default
            echo "copying ../packaging/debian/$BINNAME.init ..."
            cp ../packaging/debian/$BINNAME.init $ETCDIR/init.d
            cp ../packaging/debian/$BINNAME.postinst $ETCDIR/
        else
            echo "backup /etc/default/$BINNAME ..."
            cp /etc/default/$BINNAME $ETCDIR/default/$BINNAME.default
            echo "backup /etc/init.d/$BINNAME ..."
            cp /etc/init.d/$BINNAME $ETCDIR/init.d/$BINNAME.init
        fi
    elif [ -n "$(command -v yum)" ]; then
        if [ "$BACKUP" = "no" ]; then
            echo "copying ../packaging/debian/$BINNAME.default ..."
            cp ../packaging/rpm/$BINNAME.default $ETCDIR/default
            echo "copying ../packaging/debian/$BINNAME.init ..."
            cp ../packaging/rpm/$BINNAME.init $ETCDIR/init.d
            cp ../packaging/rpm/$BINNAME.postinst $ETCDIR/
        else
            echo "backup /etc/default/$BINNAME ..."
            cp /etc/default/$BINNAME $ETCDIR/default/$BINNAME.default
            echo "backup /etc/init.d/$BINNAME ..."
            cp /etc/init.d/$BINNAME $ETCDIR/init.d/$BINNAME.init
        fi
    fi
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

#cp $RUNSCRIPT archive

echo -e '#!/bin/bash
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

echo -e "Checking for a supported OS... \\c"

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

echo -e "Checking for a 64-bit OS... \\c"

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
    if [ -n "$(command -v apt-get)" ]; then
        if [ -f "$ETCDIR/$BINNAME.postinst" ]; then
            bash $ETCDIR/$BINNAME.postinst configure
        fi
    elif [ -n "$(command -v yum)" ]; then
        if [ -f "$ETCDIR/$BINNAME.postinst" ]; then
            bash $ETCDIR/$BINNAME.postinst configure
            passwd -l opensips
        fi
    fi
fi
cp -r $ETCDIR/$BINNAME /$ETCDIR

if [ -d "/$LIBDIR/$BINNAME" ];then
	echo "/$LIBDIR/$BINNAME already exist, make backup."
	mv /$LIBDIR/$BINNAME /$LIBDIR/$BINNAME.backup-$(date +%F-%H-%M-%S)
fi

cp -r $LIBDIR/$BINNAME /$LIBDIR/$BINNAME

echo "Done. Please edit necessary configures to run opensips."
' > archive/$RUNSCRIPT
chmod +x archive/$RUNSCRIPT
./makeself.sh archive/ $RELEASEBIN "$RELEASEBIN" ./$RUNSCRIPT 
rm -rf archive

if [ -f "$RELEASEBIN" ]; then
	if [ -d "$RELEASEDIR" ]; then
		rm -rf $RELEASEDIR
	fi
	mkdir $RELEASEDIR
	mv $RELEASEBIN $RELEASEDIR
	echo "Done. Please check file \"$RELEASEDIR/$RELEASEBIN\""
else
	echo "Error detected."
fi
