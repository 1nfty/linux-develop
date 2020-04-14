#!/bin/bash

search=/home/Github/harmony-mvn/releases/com/ibm/crl
tools=/media/sf_code/Tools/fernflower/fernflower.jar

jars=""
if [ -f "jars.txt" ]; then
  jars=`cat jars.txt |grep -v ^#`
fi

if [ -z "$jars" ]; then
  jars=`find $search -name "*.jar"`
fi

for jar in ${jars}; do
  jarFile=${jar##*/}
  zipFile=`echo ${jar##*/}|sed 's/.jar/.zip/g'`
  relPath=$(echo $jar |sed "s/`echo $jarFile`//g")
  pkgPath=`echo ${jar}|sed 's/.jar//g'`

  echo "Process $jar ..."  
  tmpFile=/tmp/${zipFile} 
  cp ${jar} ${tmpFile}
  java -jar ${tools} -hes=0 -hdc=0 -dgs=1 ${tmpFile} ${relPath}
  rm -rf ${tmpFile}

  echo "Decompress ${relPath}${zipFile} ..."
  echo ${pkgPath}
  if [ -d ${pkgPath} ]; then
    rm -rf $pkgPath
  fi
  unzip -qa ${relPath}${zipFile} -d ${pkgPath}
  rm -rf ${relPath}${zipFile}
done

echo -e "\nDone!"
