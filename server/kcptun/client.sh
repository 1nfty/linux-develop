#!/bin/bash

./bin/client_linux_amd64 -l :9527 -r 127.0.0.1:29900 -key "dou-bi.co" -crypt aes-192 -nocomp -datashard 10 -parityshard 3 -mtu 1350 -dscp 46 -mode fast2
