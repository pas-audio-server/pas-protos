#!/usr/bin/env bash

PROTO_SRCS=./src/*.proto

# Are we in the project root (that has proto definitions)?
ls .git $PROTO_SRCS &> /dev/null;
if [ $? -ne 0 ]; then
    echo "build.sh must be executed from the project root."
    exit 1
fi

# Do we have protoc?
# Check method taken from http://stackoverflow.com/a/3931779.
if type protoc &> /dev/null; then
    # Make sure the language output directories exist.
    mkdir -p cpp go
    # Then build the protos.
    protoc -I=src --cpp_out=cpp --go_out=go $PROTO_SRCS
    exit $?
else
    echo "protoc is not installed. Please run install.sh."
    exit 1
fi