#!/bin/bash

SCRIPT_PATH=`pwd`
# echo $SCRIPT_PATH
cd ${SCRIPT_PATH}

services=$(ls * |egrep -v "*.(service|sh)")
for i in ${services}; do
    server=$(echo $i)
    cd ${SCRIPT_PATH}
    sudo cp $server /etc/init.d/
    sudo chmod 755 /etc/init.d/$server
    cd /etc/init.d/ && sudo update-rc.d $server defaults 95
    echo "sudo update-rc.d $server defaults 95"
done

cd ${SCRIPT_PATH}
