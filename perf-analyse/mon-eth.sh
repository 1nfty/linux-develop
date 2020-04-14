#!/bin/bash

set -e

top $(ps -ef |grep ethermint |awk '{print "-p "$2}'|xargs)
