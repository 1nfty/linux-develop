#!/bin/bash

function main() {
    # dpkg --list | grep "^rc" |awk '{print $3}' | xargs -ti dpkg --purge {}

    apt-get clean
    apt-get autoclean
    apt-get autoremove

    deborphan |xargs -ti apt-get remove --purge -y {}

    dpkg -l |grep ^rc|awk '{print $2}' |xargs -ti dpkg -P {}

    # 删除过时的软件包
    # aptitude search ?obsolete
    # aptitude purge ~o
}
sudo su root -c "$(declare -f main); main"
