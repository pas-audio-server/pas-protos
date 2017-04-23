#!/usr/bin/env bash

LATEST_RELEASE_DATA_URL=https://api.github.com/repos/google/protobuf/releases/latest

ZIP_URL=$(curl --silent $LATEST_RELEASE_DATA_URL | python ./install_helper.py)

if [ $? -eq 0 ]; then
    echo "GOT $ZIP_URL"
    # TODO(lozord): curl or wget from the ZIP_URL, unzip, and add protoc to the
    # users's PATH variable. We probably also need to do the C++ install -_-
    exit 0
else
    echo "No zipfile download link could be found for your platform!"
    echo "Please check $LATEST_RELEASE_DATA_URL -- we could be wrong..."
    exit 1
fi