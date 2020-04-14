#!/bin/bash

# 请在 /home/Github/harmony-mvn 目录下执行该脚本
repoType=releases
user=admin:admin123

curl_upload() {
ip=$1
package=$2
version=$3
url=http://$ip:8081/repository/3rd_part
for jar in $(find $repoType -name "*.jar" |grep -v grep |grep "$package-$version"); do
    jarFile=${jar##*/}
    relPath=$(echo $jar |sed "s/`echo $jarFile`//g")
    #echo $jarFile
    #echo $relPath
    echo $ip
    for i in $(find $relPath -maxdepth 1 -name "*.*"); do
        if [ -d "$i" ]; then
            continue
        fi
        file=${i##*/}
        if [ "$file" != "" ]; then
            up=$(echo $i |sed "s/$repoType\///g")
            echo $up
            curl -v -u $user --upload-file $i $url/$up > /dev/null 2>&1
        fi
    done
    echo ""
done
}

maven_repo_abs() {
harmonyVersion=0.4.8
#serverList="localhost 192.168.1.231"
serverList="192.168.1.231"
for ip in $serverList; do
    # for fabric nodes
    curl_upload $ip solcJ-all $harmonyVersion
done
}

echo -e "\nBegin"
maven_repo_abs
echo -e 'Done!\n'
