FROM docker:18.09

ARG GIT_BRANCH
ARG GIT_COMMIT_ID
ARG GIT_DIRTY
ARG GIT_BUILD_TIME
ARG TRAVIS_BUILD_NUMBER
ARG TRAVIS_BUILD_WEB_URL

LABEL git.branch=${GIT_BRANCH}
LABEL git.commit.id=${GIT_COMMIT_ID}
LABEL git.dirty=${GIT_DIRTY}
LABEL git.build.time=${GIT_BUILD_TIME}
LABEL travis.build.number=${TRAVIS_BUILD_NUMBER}
LABEL travis.build.web.url=${TRAVIS_BUILD_WEB_URL}

RUN apk add --no-cache curl

VOLUME /root/.docker/machine

RUN curl -L https://github.com/docker/machine/releases/download/v0.16.0/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine && \
            install /tmp/docker-machine /usr/local/bin/docker-machine

ENTRYPOINT ["docker-machine"]
