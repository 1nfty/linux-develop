#!/bin/bash

# echo $PATH
oldGoPath=${GOPATH}
export GOPATH=$(readlink -f `pwd`)
if [ "${oldGoPath}" != "" ]; then
    removedGoPath=$(echo ${PATH} |sed 's/:/\n/g' |grep -v ${oldGoPath} |sed ':a;N;s/\n/:/;ta;')
    export PATH=${removedGoPath}:${GOPATH}/bin;
else
    export PATH=${PATH}:${GOPATH}/bin;
fi

echo ""
echo $GOPATH
echo $PATH
echo ""

cd $GOPATH; pwd
