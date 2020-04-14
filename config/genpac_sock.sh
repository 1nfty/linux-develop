#!/bin/bash

genpac --proxy="SOCKS5 192.168.1.30:1080" --gfwlist-proxy="SOCKS5 192.168.1.30:1080" -o autoproxy_sock5.pac --gfwlist-url="https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt"
