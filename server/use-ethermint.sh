#!/bin/bash

TAG_ETHEREUM=$GOPATH/src/github.com/ethereum
TAG_TENDERMINT=$GOPATH/src/github.com/tendermint

function printHelp() {
    echo "Usage: ./`basename $0` [-t dist|dev|ori|null]"
    exit 1
}

function validateArgs () {
    if [ -z "${SELECT_SRC}" ]; then
        printHelp
    fi
}

function doLink() {
    src_dir=$1
    tag_dir=$2
    if [ -d "${src_dir}" ]; then
        ln -fs ${src_dir} ${tag_dir}
    else
        echo "source dir is not exist. ${src_dir}"
    fi
}

# parse script args
while getopts ":t:" OPTION; do
    case ${OPTION} in
        t)
            SELECT_SRC=$OPTARG
            rm -f $TAG_ETHEREUM $TAG_TENDERMINT
            ;;
        ?)
            printHelp
    esac
done

# process selected source code
function execute() {
    # dist, ori, dev 
    SOURCE_ROOT=/home/OpenSource
    case ${SELECT_SRC} in
        "dist")
            dir=$SOURCE_ROOT/energy.com/greenchain
            ;;
        "dev")
            dir=$SOURCE_ROOT/energy.com/greenelement
            ;;
        "ori")
            dir=$SOURCE_ROOT/github.com/ethermint
            ;;
        "null")
            echo "reset success."
            exit 0
            ;;
        ?)
            echo "haha"
            printHelp
    esac
    
    doLink ${dir}/ethereum ${TAG_ETHEREUM}
    doLink ${dir}/tendermint ${TAG_TENDERMINT}
}

validateArgs 
execute

