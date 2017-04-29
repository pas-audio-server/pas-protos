#!/usr/bin/env bash

# Exit with failure immediately if anything below fails.
set -e

# Constants.
readonly PROTO_SRCS=./src/*.proto

# Are we in the project root (that has proto definitions)?
ls .git $PROTO_SRCS &> /dev/null;
if [ $? -ne 0 ]; then
    echo "build.sh must be executed from the project root."
    exit 1
fi

# Do we have protoc?
# Check method taken from http://stackoverflow.com/a/3931779.
if type protoc &> /dev/null; then
    OK=0
    # Make sure the language output directories exist.
    mkdir -p cpp go
    OK=$? || $OK
    # Then build the protos.
    protoc -I=./src --cpp_out=./cpp --go_out=./go $PROTO_SRCS
    OK=$? || $OK

    if [ $OK -eq 0 ]; then
        echo "Success."
        E="export PAS_PROTO_ROOT=\"$PWD\""
        echo "You may want to add the following line to your ~/.bash{rc,_profile}:"
        echo -e "\t$E"
        exit 0
    else
        echo "Failure."
        exit 1
    fi
else
    echo "protoc is not installed. Please run install.sh."
    exit 1
fi