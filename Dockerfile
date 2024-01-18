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

RUN     wget \
        -O /interproscan.tar.gz \
        https://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/5.65-97.0/interproscan-5.65-97.0-64-bit.tar.gz

RUN     mkdir /interproscan  && \
        tar \
        -xvf \
        /interproscan.tar.gz \
        -C /interproscan \
        --strip-components 1 && \
        rm /interproscan.tar.gz

RUN     sed -i \
        "s|^\(data.directory=\).*$|\1/interproscan/data|" \
        /interproscan/interproscan.properties"

RUN     find /interproscan/data -type f -name "*.hmm" \
        -exec /interproscan/bin/hmmer/hmmer3/3.3/hmmpress {}  \; 

ENTRYPOINT ["/interproscan/interproscan.sh"]
