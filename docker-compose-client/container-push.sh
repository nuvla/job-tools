#!/bin/bash -xe


GIT_BRANCH=$(echo ${GITHUB_REF} | awk -F'/' '{print $(NF)}' | sed -e 's/[^a-z0-9\._-]/-/g')

if [[ "${GIT_BRANCH}" == "master" ]]
then
  DOCKER_ORG=nuvla
else
  DOCKER_ORG=nuvladev
fi

DOCKER_IMAGE=job-docker-compose-client
MANIFEST=${DOCKER_ORG}/${DOCKER_IMAGE}:${GIT_BRANCH}

platforms=(amd64 arm64 arm)
manifest_args=(${MANIFEST})

#
# login to docker hub
#

unset HISTFILE
echo ${SIXSQ_DOCKER_PASSWORD} | docker login -u ${SIXSQ_DOCKER_USERNAME} --password-stdin

#
# push all generated images
#

for platform in "${platforms[@]}"; do
    docker push ${MANIFEST}-${platform}
    manifest_args+=("${MANIFEST}-${platform}")    
done

#
# create manifest, update, and push
#

export DOCKER_CLI_EXPERIMENTAL=enabled
docker manifest create "${manifest_args[@]}"

for platform in "${platforms[@]}"; do
    docker manifest annotate ${MANIFEST} ${MANIFEST}-${platform} --arch ${platform}
done

docker manifest push --purge ${MANIFEST}
