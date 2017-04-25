#!/usr/bin/env bash

# Constants.
readonly LATEST_RELEASE_DATA_URL=https://api.github.com/repos/google/protobuf/releases/latest
readonly TMP_DIR=/tmp/_download_protoc

# Get the JSON data from the GitHub API and pipe it into our helper to figure
# out the URL from which to download the zipfile.
ZIP_URL=$(curl --silent $LATEST_RELEASE_DATA_URL | python ./install_helper.py)

if [ $? -eq 0 ]; then
    # Create a temporary directory for the install and unzip.
    mkdir -p $TMP_DIR
    
    # Download the zipfile.
    # TODO(lozord): How to safely get around --no-check-certificate?
    wget --quiet --no-check-certificate \
        -O $TMP_DIR/protoc_install.zip $ZIP_URL
    
    # Unzip the zipfile to a directory with the "same name".
    unzip -q $TMP_DIR/protoc_install.zip \
        -d $TMP_DIR/protoc_install
    
    # Put the protoc binary in the user's $PATH.
    cp $TMP_DIR/protoc_install/bin/protoc /usr/local/bin
    
    # Since we don't exit early (bash swallows errors), we will always reach
    # this cleanup step.
    rm -rf $TMP_DIR

    exit 0
else
    echo "No zipfile download link could be found for your platform!"
    echo "Please check $LATEST_RELEASE_DATA_URL -- we could be wrong..."
    exit 1
fi