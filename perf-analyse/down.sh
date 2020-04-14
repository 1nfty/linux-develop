#!/bin/bash

set -e

if [[ -z $1 || "$1" == "" ]]; then
    scp -r root@47.74.154.218:/root/eth/perf-xubing .
else
    scp -r root@47.74.154.218:/root/eth/perf-xubing/$1 .
fi
