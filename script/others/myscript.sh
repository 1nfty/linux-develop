#!/bin/bash

while read line; do yum remove -y ${line}; done < pkg
