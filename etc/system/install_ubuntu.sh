#!/bin/bash

currenPath=`pwd`
targetPath=/lib/systemd/system

function install_service() {
    for i in $(ls $currenPath |grep '.service'); do
        target=$targetPath/$i
        
        rm -f $target; cp $currenPath/$i $target
        systemctl enable $i
    done
}

function start_service() {
    systemctl daemon-reload
    for i in $(ls $currenPath |grep '.service'); do
        echo $i
        systemctl start $i
        systemctl status $i
    done
}

install_service
start_service
