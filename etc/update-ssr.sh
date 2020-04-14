#!/bin/bash

# set -ex

ROOT_DIR=$(cd `dirname $(readlink -f "$0")` && pwd)

# 注意:前两行为个人使用,请勿删除
# 顺序：1.公司; 2.个人
ssr_text="
ssr://ZnEuZW5lcmd5LWJsb2NrY2hhaW4uY29tOjkwODM6b3JpZ2luOnJjNC1tZDU6cGxhaW46Ulc1bGNtZDVRREV5TXpRMS8_cmVtYXJrcz01WVdzNVktNCZncm91cD1kQzV0WlM5RFRsTlRVZw
ssr://MTA0LjIyNC4xODUuMTYyOjE0MzM6b3JpZ2luOmFlcy0xMjgtY2ZiOnBsYWluOmFIVmhkMlZwT20weE1BLz9yZW1hcmtzPTVwQ3M1NU9tNWJlbCZncm91cD1kQzV0WlM5RFRsTlRVZw
"
ss_text="
ss://cmM0LW1kNTpFbmVyZ3lAMTIzNDU@fq.energy-blockchain.com:9083#%E5%85%AC%E5%8F%B8
ss://YWVzLTEyOC1jZmI6aHVhd2VpOm0xMA@104.224.185.162:1433#%E6%90%AC%E7%93%A6%E5%B7%A5
"

function del_history_commit() {
    git checkout --orphan latest_branch
    git add -A
    git commit -am "commit message"
    git branch -D master
    git branch -m master
    git push -f origin master
    git branch --set-upstream-to=origin/master master
}

function urldecode() {
    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}

function write_ss_context() {
    out_file=$1
    ss_encode=$(urldecode $2 |sed 's/ss:\/\///g' |sed 's/#/=/g')
    ss_data=${ss_encode%=*}
    ss_address=${ss_data#*@}
    ss_decode=$(echo "${ss_data%@*}=" |base64 -d 2>/dev/null)

    echo "ss row: ${ss_address} ${ss_decode}"
    # {
    # "remote_dns": "dns.google",
    # "metered": false,
    # "proxy_apps": { "enabled": false },
    # "udpdns": false
    # }
cat << EOF >> $out_file
  {
    "server": "${ss_address%:*}",
    "server_port": "${ss_address#*:}",
    "password": "${ss_decode#*:}",
    "method": "${ss_decode%%:*}",
    "remarks": "${ss_encode#*=}",
    "route": "bypass-lan-china",
    "ipv6": true
  },
EOF
}

# update data for subscribe
function get_content() {
    echo "[" > ss_temp
    for ss in ${ss_text}; do
        write_ss_context ss_temp $ss
    done
    echo "]" >> ss_temp
    cat ss_temp |sed 'N;s/\n//g' |sed 's/,]/]/g' |jq . > ss-json
    rm -rf ss_temp

    echo $ssr_text | base64 > ssrsub
}

# main function code
function main() {
    OLD=`pwd`
    cd $ROOT_DIR
    get_content
    cd $OLD
    del_history_commit > /dev/null
    echo ""
}
main
