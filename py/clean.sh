#!/bin/bash

if [ $(find -name \*.pyc|wc -l) != 0 ];then
    rm *.pyc
fi

if [ -f ".auto" ];then
    rm .auto
fi

if [ -d "dist" ];then
    rm -r dist
fi

if [ -d "build" ];then
    rm -r build
fi

if [ -f "server.spec" ];then
    rm server.spec
fi

echo "DONE!"
