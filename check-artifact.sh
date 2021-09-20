#!/bin/bash

set -xe

ARTIFACT_FULL_URL=$1
EXTERNAl_URL=$2

# get artifact name from the artifact full url
ARTIFACT_NAME=$(echo ${ARTIFACT_FULL_URL} | rev | cut -d'/' -f 1 | rev)
echo $ARTIFACT_NAME

# chech whether artifact is available at given path or not in the artifactory
# checking status code. if [200] the artifact available in artifactory
# [404] artifact not available in artifactory
check_artifact=$(curl -s -o /dev/null -w "%{http_code}" -u ${USERNAME}:${PASSWORD} ${ARTIFACT_FULL_URL})

#echo $check_url

case $check_artifact in
[200]*)
# if artifact available then download it from artifactory.
  echo "file exists: $ARTIFACT_FULL_URL"
  curl -u ${USERNAME}:${PASSWORD} -Lo $ARTIFACT_NAME $ARTIFACT_FULL_URL
  ;;
[404]*)
# if artifact not available in artifactory then download it from external source URL and upload it to artifactory.
  echo "file does not exist: $ARTIFACT_FULL_URL"
  echo "Downloading from external source $EXTERNAL_URL"
  curl -Lo $ARTIFACT_NAME $EXTERNAl_URL
  echo "Download complete from external url. Uploading to artifactory"
  # calculate checksums
  sha256=$(openssl dgst -sha256 ${ARTIFACT_NAME}|sed 's/^SHA256.*= //')
  sha1=$(openssl dgst -sha1 ${ARTIFACT_NAME}|sed 's/^SHA.*= //')
  md5=$(openssl dgst -md5 ${ARTIFACT_NAME}|sed 's/^MD5.*= //')
  # Upload artifact to artifactory
  curl -u${USERNAME}:${PASSWORD} -T ${ARTIFACT_NAME} -H "X-Checksum-Sha256:${sha256}" -H "X-Checksum-Sha1:${sha1}" -H "X-Checksum-md5:${md5}" ${ARTIFACT_FULL_URL}
  ;;
*)
  echo "URL error - HTTP error code $check_artifact: $ARTIFACT_FULL_URL"
  exit 1
  ;;
esac