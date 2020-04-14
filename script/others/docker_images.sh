#!/bin/bash

DOCKER_SERVER=192.168.1.160
DOCKER_OPUSER=bing.xu
DOCKER_PASSWD=Energy@123

function do_login() {
    if [[ "${DOCKER_OPUSER}" != "" ]] && [[ "${DOCKER_PASSWD}" != "" ]]; then
        docker login -u ${DOCKER_OPUSER} -p ${DOCKER_PASSWD} ${DOCKER_SERVER} 2>&1 |grep -v 'WARNING'
    fi
}

function do_logout() {
    if [[ "${DOCKER_OPUSER}" != "" ]] && [[ "${DOCKER_PASSWD}" != "" ]]; then
        docker logout ${DOCKER_SERVER} 
    fi
}

function pull_image() {
    img=$1
    version=$2

    image_package=${DOCKER_SERVER}/${img}:${version}
    docker pull ${image_package}
    
    image_id=$(docker images |grep ${DOCKER_SERVER}/${img} |grep ${version} |awk '{print $3}' |uniq)
    docker tag ${image_id} ${img}:${version}
    docker rmi -f ${image_package}
}

function do_pull() {
    images=$1
    version=$2

    do_login
    for img in ${images}; do
        pull_image ${img} ${version}
    done
    do_logout
}

function do_pull_all() {
    version=$1

    names="tools orderer peer ccenv"
    for name in ${names}; do
        images="${images} hyperledger/fabric-${name}"
    done

    do_login
    for img in ${images}; do
        pull_image ${img} ${version}
    done
    do_logout
}

function push_image() {
    img=$1
    version=$2

    image_id=$(docker images |grep ${img} |grep ${version} |awk '{print $3}' |uniq)
    image_package=${DOCKER_SERVER}/${img}:${version}
    docker tag ${image_id} ${image_package}
    docker push ${image_package}
    docker rmi -f ${image_package}
}

function do_push() {
    images=$1
    version=$2
    
    do_login
    for img in ${images}; do
        push_image ${img} ${version}
    done
    do_logout
}

function do_push_all() {
    version=$1
    
    do_login
    images=${IMG_NAME}
    if [ "${IMG_NAME}" == "" ]; then
        images=$(docker images |grep ${version} |awk '{print $1}' |xargs)
    fi
    for img in ${images}; do
        push_image ${img} ${version}
    done
    do_logout
}

function validateArgs() {
    if [[ "${OP_TYPE}" == "" ]]; then
        echo "input operate parameter invalid, operate is ${OP_TYPE} ."
        exit 1
    elif [[ "${OP_TYPE}" != "login" ]]; then
        if [[ "${OP_TYPE}" == "pushall" ]] || [[ "${OP_TYPE}" == "pullall" ]]; then
            if [[ "${IMG_VERSION}" == "" ]]; then
                echo "input image parameter invalid, version is ${IMG_VERSION} ."
                exit 1
            fi
        else
            if [[ "${IMG_NAME}" == "" ]] || [[ "${IMG_VERSION}" == "" ]]; then
                echo "input image parameter invalid, name is ${IMG_NAME}, version is ${IMG_VERSION} ."
                exit 1
            fi
        fi
    fi
}

function execute() {
    case ${1} in
        "login")
            do_login
            ;;
        "logout")
            do_logout
            ;;
        "pull")
            do_pull ${1} ${2}
            ;;
        "pullall")
            do_pull_all ${2}
            ;;
        "push")
            do_push ${1} ${2}
            ;;
        "pushall")
            do_push_all ${2}
            ;;
    esac
}

# parse script args
while getopts ":t:s:n:v:" OPTION; do
    case ${OPTION} in
        t)
            OP_TYPE=$OPTARG
            ;;
        s)
            DOCKER_SERVER=$OPTARG
            ;;
        n)
            IMG_NAME=$OPTARG
            ;;
        v)
            IMG_VERSION=$OPTARG
            ;;
        ?)
            echo "parameter error."
            exit 1
    esac
done

validateArgs
echo "do ${OP_TYPE} ${IMG_NAME} ${IMG_VERSION} ..."
execute ${OP_TYPE} ${IMG_NAME} ${IMG_VERSION}

