#!/bin/bash

# TODO: Allow this stuff to be overridden on the command line or with environment variables
BUILD_NUM=`date -u +%Y%m%d_%H%M%S`
GIT_TAG="v$BUILD_NUM"
DOCKER_TAG="$BUILD_NUM"

docker build --rm -f Dockerfile -t bash-shell.net:master --build-arg REPO_REFERENCE=master . 
