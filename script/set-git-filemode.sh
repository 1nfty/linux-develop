#!/bin/bash

scandir=$1
echo "search dir is $scandir"

for i in $(find $scandir -name ".git"); do
    gitdir=$i
    if [[ $gitdir =~ ".git" ]]; then
        nogit=`echo $gitdir |sed s/\.git//g`
        if [ -d $nogit ]; then
            echo $nogit
            cd $nogit; git config  core.filemode false; cd --
        fi
    fi
done
