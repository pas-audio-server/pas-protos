#!/usr/bin/env bash

# Constants.
readonly LATEST_RELEASE_DATA_URL=https://api.github.com/repos/google/protobuf/releases/latest
readonly TMP_DIR=/tmp/_download_protoc

# Get the JSON data from the GitHub API and pipe it into our helper to figure
# out the URL from which to download the zipfile.
ZIP_URL=$(curl --silent $LATEST_RELEASE_DATA_URL | python ./install_helper.py)

if [ $? -eq 0 ]; then
    OK=0

    # Create a temporary directory for the install and unzip.
    mkdir -p $TMP_DIR
    OK=$? || $OK
    
    # Download the zipfile.
    # TODO(lozord): How to safely get around --no-check-certificate?
    wget --quiet --no-check-certificate \
        -O $TMP_DIR/protoc_install.zip $ZIP_URL
    OK=$? || $OK
    
    # Unzip the zipfile to a directory with the "same name".
    unzip -q $TMP_DIR/protoc_install.zip \
        -d $TMP_DIR/protoc_install
    OK=$? || $OK
    
    # Put the protoc binary in the user's $PATH.
    cp $TMP_DIR/protoc_install/bin/protoc /usr/local/bin
    OK=$? || $OK

    # Since we don't exit early (bash swallows errors), we will always reach
    # this cleanup step.
    rm -rf $TMP_DIR
    OK=$? || $OK

    # Install the Golang helpers proto and protoc-gen-go.
    # Assume that the user has their GOPATH, etc. set up already.
    # This commmand will print an error message if not.
    go get -u github.com/golang/protobuf/{proto,protoc-gen-go}
    OK=$? || $OK

    if [ $OK -eq 0 ]; then
        echo "Success."
    else
        echo "Failure."
    fi

    exit $OK
else
    echo "No zipfile download link could be found for your platform!"
    echo "Please check $LATEST_RELEASE_DATA_URL -- we could be wrong..."
    exit 1
fi