Bootstrap: docker
From: ubuntu:22.04

%environment
    export LC_ALL=C
    export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
    export PATH="/interproscan:/usr/lib/jvm/java-11-openjdk-amd64/bin:${PATH}"
    export DEBIAN_FRONTEND=noninteractive

%post
    export DEBIAN_FRONTEND=noninteractive
    export LC_ALL=C
    export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
    export PATH="/interproscan:/usr/lib/jvm/java-11-openjdk-amd64/bin:${PATH}"

    # set up apt
    apt-get clean
    rm -r /var/lib/apt/lists/*
    apt-get update
    apt-get upgrade -y --fix-missing

    # dependencies
    apt update
    apt install -y \
        build-essential \
        default-jre-headless \
        libdw1 \
        pigz \
        python3 \
        wget

    # download and install interproscan, takes hours
    wget \
    	-O /interproscan.tar.gz \
        https://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/5.65-97.0/interproscan-5.65-97.0-64-bit.tar.gz

    mkdir /interproscan
    tar \
        --use-compress-program=pigz \
        -xvf \
        /interproscan.tar.gz \
        -C /interproscan \
        --strip-components 1
    rm /interproscan.tar.gz

    # set up the data directories
    sed -i \
        "s|^\(data.directory=\).*$|\1/interproscan/data|" \
        /interproscan/interproscan.properties"

    find /interproscan/data -type f -name "*.hmm" \
        -exec /interproscan/bin/hmmer/hmmer3/3.3/hmmpress {}  \; 
