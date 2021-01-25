#!/bin/bash -xe

GIT_BRANCH=$(echo ${GITHUB_REF} | awk -F'/' '{print $(NF)}' | sed -e 's/[^a-z0-9\._-]/-/g')

if [[ "${GIT_BRANCH}" == "master" ]]
then
  DOCKER_ORG=nuvlabox
else
  DOCKER_ORG=nuvladev
fi

DOCKER_IMAGE=job-docker-compose-client
MANIFEST=${DOCKER_ORG}/${DOCKER_IMAGE}:${GIT_BRANCH}

platforms=(amd64 arm64 arm)

#
# remove any previous builds
#

rm -Rf target/*.tar
mkdir -p target

#
# generate image for each platform
#

for platform in "${platforms[@]}"; do 
    docker run --rm --privileged -v ${PWD}:/tmp/work --entrypoint buildctl-daemonless.sh moby/buildkit:master \
           build \
           --frontend dockerfile.v0 \
           --opt platform=linux/${platform} \
           --opt filename=./Dockerfile \
           --opt build-arg:GIT_BRANCH=${GIT_BRANCH} \
           --opt build-arg:GIT_BUILD_TIME=${GIT_BUILD_TIME} \
           --opt build-arg:GIT_COMMIT_ID=${GITHUB_SHA} \
           --opt build-arg:GITHUB_RUN_NUMBER=${GITHUB_RUN_NUMBER} \
           --opt build-arg:GITHUB_RUN_ID=${GITHUB_RUN_ID} \
           --output type=docker,name=${MANIFEST}-${platform},dest=/tmp/work/target/${DOCKER_IMAGE}-${platform}.docker.tar \
           --local context=/tmp/work \
           --local dockerfile=/tmp/work \
           --progress plain

done

#
# load all generated images
#

for platform in "${platforms[@]}"; do
    docker load --input ./target/${DOCKER_IMAGE}-${platform}.docker.tar
done

