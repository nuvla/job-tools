FROM docker:18.09.1-dind

VOLUME /root/.docker

ENV DOCKER_HOST 0.0.0.0:2376

ENTRYPOINT ["docker", "--tlsverify=false"]
