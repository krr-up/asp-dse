#!/bin/bash

# This script takes two arguments: 1 input file and 1 output file
# Every line is embedded in the legacy term: legacy('content of line').

if [ -n "$1" ]; then
    if [ -n "$2" ]; then
        if [[ ! -f $2 ]]; then
            > $2
        fi

        sed 's/^/legacy(/' $1 > $2
        sed -i s/'\.'/').'/g $2

    else
        echo "The output file (second parameter) was not set"
    fi
else
    echo "The input file (first parameter) was not set"
fi