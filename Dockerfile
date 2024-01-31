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
        --use-compress-program=pigz \
        -xvf \
        /interproscan.tar.gz \
        -C /interproscan \
        --strip-components 1 && \
        rm /interproscan.tar.gz

# set up the data directories
RUN     sed -i \
        "s|^\(data.directory=\).*$|\1/interproscan/data|" \
        /interproscan/interproscan.properties

# Fix the duplicate DB keys. See
# https://github.com/ebi-pf-team/interproscan/issues/305#issue-1557871512
RUN    for f in /interproscan/data/sfld/*/sfld.hmm /interproscan/data/superfamily/*/hmmlib_*[0-9]; do \
        cp $f $f.bak; \
        perl -lne '$_=~s/[\s\n]+$//g;if(/^(NAME|ACC) +(.*)$/){if(exists $d{$2}){$d{$2}+=1;$_.="-$d{$2}"}else{$d{$2}=0;}}print "$_"' $f > $f.tmp; mv $f.tmp $f; \
        done

# set up database
WORKDIR /interproscan
RUN        python3 setup.py /interproscan/interproscan.properties

ENTRYPOINT ["/interproscan/interproscan.sh"]
