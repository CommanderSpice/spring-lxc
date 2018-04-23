#!/bin/bash

set -e

BUILDBOTDIR=/home/buildslave

apt update
apt -y install g++ make cmake p7zip-full ninja-build \
	libxmu-dev libxi-dev default-jre default-jdk \
	libcurl4-gnutls-dev libssl-dev libopenal-dev libvorbis-dev \
	libogg-dev libsdl2-dev libfreetype6-dev libfontconfig1-dev \
	freeglut3-dev libgif-dev \
	buildbot-slave

buildslave create-slave $BUILDBOTDIR localhost:8888 buildslave-x64 changeme
chown -R buildbot:buildbot $BUILDBOTDIR


