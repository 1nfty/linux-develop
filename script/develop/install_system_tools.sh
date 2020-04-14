#!/bin/bash

curr_dir=`pwd`
echo "start install system command"
apt-get install -y openssh-server safe-rm dos2unix jq git python3-dev

echo "start install docker ..."
apt-get install -y docker docker.io

echo "start install develop tools ..."
apt-get install -y cmake g++ python-dev
apt-get install -y libltdl-dev libssl-dev libtool curl git unzip g++
apt-get install -y make cmake autoconf automake 

echo "finished ..."
cd ${curr_dir}
