FROM ubuntu:24.04

MAINTAINER Mathias Lafeldt <mathias.lafeldt@gmail.com>

ENV TOOLCHAIN_VERSION 0359891a9e65785a12fab0b0f9479d81f0d146b0

ENV PS3DEV  /ps3dev
ENV PSL1GHT $PS3DEV
ENV PATH    $PATH:$PS3DEV/bin:$PS3DEV/ppu/bin:$PS3DEV/spu/bin:${PS3DEV}/portlibs/ppu/bin

ENV DEBIAN_FRONTEND noninteractive

COPY toolchain-docker.sh /

RUN apt update \
    && apt upgrade -y \
    && apt install -y \
        autoconf \
        automake \
        bison \
        bzip2 \
        ca-certificates \
        flex \
        g++ \
        gcc \
        git \
        libelf-dev \
        libgmp3-dev \
        libncurses5-dev \
        libssl-dev \
        libtool \
        libtool-bin \
        make \
        patch \
        pkg-config \
        python-dev-is-python3 \
        texinfo \
        vim \
        wget \
        xz-utils \
        zlib1g-dev \

# Fixes certificate errors with letsencrypt in ARMv7 echo "ca_certificate=/etc/ssl/certs/ca-certificates.crt" >> /etc/wgetrc \
&& echo "check_certificate = off" >> ~/.wgetrc \

# pass toolchain's check for gmp
&& ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h \
    && git clone https://github.com/ps3dev/ps3toolchain.git /toolchain \
    && cd /toolchain \
    && git checkout -qf $TOOLCHAIN_VERSION \
    && /toolchain-docker.sh \
    && rm -rf /toolchain* /var/lib/apt/lists/*

WORKDIR /src
CMD ["/bin/bash"]
