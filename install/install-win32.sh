#!/bin/bash

set -e
source "$(dirname "$0")"/make_static_libs_common.sh

dpkg --add-architecture i386

apt update
apt -y install \
	ninja-build \
	buildbot-slave \
	autossh \
	pwgen \
	default-jre default-jdk \
	nsis \
	wine:i386

# https://mxe.cc/#requirements-debian
apt -y install \
    autoconf \
    automake \
    autopoint \
    bash \
    bison \
    bzip2 \
    flex \
    g++ \
    g++-multilib \
    gettext \
    git \
    gperf \
    intltool \
    libc6-dev-i386 \
    libgdk-pixbuf2.0-dev \
    libltdl-dev \
    libssl-dev \
    libtool-bin \
    libxml-parser-perl \
    lzip \
    make \
    openssl \
    p7zip-full \
    patch \
    perl \
    pkg-config \
    python \
    ruby \
    sed \
    unzip \
    wget \
    xz-utils
