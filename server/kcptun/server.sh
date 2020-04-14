#!/bin/bash

cd /home/DevTools/linux-develop/server/kcptun
./bin/server_linux_amd64 -c ./server-config.json 2>&1 &
echo "Kcptun started."
