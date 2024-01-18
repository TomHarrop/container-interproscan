FROM ubuntu:22.04

LABEL SOFTWARE_NAME ubuntu 20.04
LABEL MAINTAINER "Tom Harrop"
LABEL version=5bf6256

ENV LC_ALL=C
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH="/interproscan:/usr/lib/jvm/java-11-openjdk-amd64/bin:${PATH}"
ENV DEBIAN_FRONTEND=noninteractive

RUN     apt-get clean && \
        rm -r /var/lib/apt/lists/* && \
        apt-get update && apt-get upgrade -y --fix-missing

RUN     apt-get update && apt-get install -y  --no-install-recommends \
                build-essential \
                default-jre-headless \
                libdw1 \
                pigz \
                python3 \
                wget

ENTRYPOINT ["/usr/bin/cat /etc/os-release"]
