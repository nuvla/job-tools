FROM docker:18.09

RUN apk add --no-cache curl

VOLUME /root/.docker/machine

RUN curl -L https://github.com/docker/machine/releases/download/v0.16.0/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine && \
            install /tmp/docker-machine /usr/local/bin/docker-machine

ENTRYPOINT ["docker-machine"]
