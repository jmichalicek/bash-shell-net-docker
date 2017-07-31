#!/bin/bash

#BUILD_NUM=`date +%Y%m%d_%H%M%S`
docker build --rm -f Dockerfile -t bash-shell-net:$VERSION --build-arg REPO_REFERENCE=$VERSION .
