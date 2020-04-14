#!/bin/bash

dir=$(date '+%Y%m%d%H%M%S')

mkdir -p ${dir}
#for((i=1; i<=10; i++)); do 
while (true); do 
    file=${dir}/heap_$(date '+%Y%m%d%H%M%S').svg
    echo $file
    go tool pprof -inuse_space -cum -svg http://127.0.0.1:6061/debug/pprof/heap > ${file}
    sleep 5
done
