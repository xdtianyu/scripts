#!/bin/bash
#title           :make.sh
#description     :This script is called by autobuild.sh.
#author          :xdtianyu@gmail.com
#date            :20141205
#version         :1.0 final
#usage           :bash make.sh
#bash_version    :4.3.11(1)-release

GIT_DIR=/home/builder/opensips-git
BUILD_DIR=/home/builder/opensips-autobuild
SUDO_PASSWORD="123456" # PLEASE MODIFY THIS

PUSH_SERVER="sip.example.com" # PLEASE MODIFY THIS
PUSH_PORT="12345" # PLEASE MODIFY THIS

ERROR_MSG=""
ERROR_OUTPUT="/tmp/error.out"

if [ -f "$ERROR_OUTPUT" ];then
    echo $SUDO_PASSWORD | sudo -S rm -rf $ERROR_OUTPUT
fi

function finish()
{
    if [ ! -z "$ERROR_MSG" ];then
       echo "$ERROR_MSG" >> $ERROR_OUTPUT 
    fi
    exit 0;
}

if [ ! -d "$GIT_DIR" ];then
    echo "git source directory not exist, exit.";
    ERROR_MSG="git directory not exist.";
    finish;
fi

if [ -d "$BUILD_DIR" ];then
    echo "build directory exist, remove now.";
    echo $SUDO_PASSWORD|sudo -S rm -r $BUILD_DIR;
fi

cd $GIT_DIR

git clean -df

echo "pull git source to the latest."
git pull

mkdir -p $BUILD_DIR
cd $BUILD_DIR

echo "copy source to $BUILD_DIR"
cp -r $GIT_DIR/* .

echo -e "\nmake clean\n"
make clean

echo -e "\nmake all\n"
make all|| ERROR_MSG="build failed."

if [ ! -z "$ERROR_MSG" ];then
    finish;
fi

echo -e "\nmake backup\n"
cd install
echo $SUDO_PASSWORD|sudo -S ./build.sh --backup
cd ..
echo -e "\nmake install\n"
echo $SUDO_PASSWORD|sudo -S make install

echo -e "\nmake opensips.run\n"
cd install
echo $SUDO_PASSWORD|sudo -S ./build.sh

echo -e "\nrestory backup\n"
cd backup
echo $SUDO_PASSWORD|sudo -S ./opensips*

cd ..
echo -e "\nclean backup\n"
echo $SUDO_PASSWORD|sudo -S ./build.sh -c --backup

cd ..

if [ -f "install/release/opensips.run" ];then
    echo -e "\npush opensips.run to $PUSH_SERVER\n"
    scp -P $PUSH_PORT install/release/opensips.run root@$PUSH_SERVER:/root
else
    echo -e "\nError, no release find.\n"
    ERROR_MSG="Build failed, please check log for detail."
    finish;
fi
