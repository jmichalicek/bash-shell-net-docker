#!/bin/bash

# TODO: Allow this stuff to be overridden on the command line or with environment variables
BUILD_NUM=`date +%Y%m%d_%H%M%S`
GIT_TAG="v$BUILD_NUM"
DOCKER_TAG="$BUILD_NUM"

TAG_JSON="{\"tag_name\": \"$GIT_TAG\", \"target_commitish\": \"master\", \"name\": \"$GIT_TAG\", \"body\": \"Release of version $BUILD_NUM.\", \"draft\": false, \"prerelease\": false}"

curl -s -k -X POST -H "Content-Type: application/json" "https://api.github.com/repos/jmichalicek/bash-shell.net/releases?access_token=$GITHUB_ACCESS_TOKEN" -d "$TAG_JSON"
docker build --rm -f Dockerfile -t registry.gitlab.com/jmichalicek/bash-shell.net:$DOCKER_TAG --build-arg REPO_REFERENCE=$GIT_TAG .
docker push registry.gitlab.com/jmichalicek/bash-shell.net:$DOCKER_TAG
