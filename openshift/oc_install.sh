#! /bin/bash

set -e

OC_VERSION=${OC_VERSION:-'latest'}

if [ "$OC_VERSION" == "latest" ]; then
  GITHUB_URL="https://api.github.com/repos/openshift/origin/releases/latest"
else
  GITHUB_URL="https://api.github.com/repos/openshift/origin/releases/tags/${OC_VERSION}"
fi

#BROWSER_DOWNLOAD_URL=$(curl -s ${GITHUB_URL} | jq -r ".assets[] | select(.name | test(\"client.*linux.*64\")) | .browser_download_url")
BROWSER_DOWNLOAD_URL=$(curl -s ${GITHUB_URL} | jq -r ".assets[].browser_download_url" | grep -e "client.*linux.*64")

curl -sL --retry 3 $BROWSER_DOWNLOAD_URL | tar -xz

DIR_NAME=`echo ${BROWSER_DOWNLOAD_URL##*/} | awk -F'.tar.gz' '{print $1}'`
mv $DIR_NAME/oc /usr/local/bin/oc
rm -rf $DIR_NAME

# Check if our oc client is ready for action
oc version