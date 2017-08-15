FROM ubuntu:14.04

MAINTAINER Mathias Lafeldt <mathias.lafeldt@gmail.com>

ENV TOOLCHAIN_VERSION 78cea97c5a1464db965f205d3ec07a5ad649c88a

ENV PS3DEV  /ps3dev
ENV PSL1GHT $PS3DEV
ENV PATH    $PATH:$PS3DEV/bin:$PS3DEV/ppu/bin:$PS3DEV/spu/bin

ENV DEBIAN_FRONTEND noninteractive

COPY toolchain-docker.sh /

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        autoconf \
        automake \
        bison \
        bzip2 \
        flex \
        g++ \
        gcc \
        git \
        libelf-dev \
        libgmp3-dev \
        libncurses5-dev \
        libssl-dev \
        libtool \
        make \
        patch \
        pkg-config \
        python-dev \
        texinfo \
        vim \
        wget \
        zlib1g-dev \
    # pass toolchain's check for gmp
    && ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h \
    && git clone git://github.com/ps3dev/ps3toolchain.git /toolchain \
    && cd /toolchain \
    && git checkout -qf $TOOLCHAIN_VERSION \
    && /toolchain-docker.sh \
    && rm -rf /toolchain* /var/lib/apt/lists/*

WORKDIR /src
CMD ["/bin/bash"]
