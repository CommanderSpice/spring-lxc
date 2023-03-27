#!/bin/bash

set -e

if [ $# -eq 0 ]; then
	echo "Missing destination directory"
	exit 2
fi

export WORKDIR=$1
export TMPDIR=${WORKDIR}/tmp
export INCLUDEDIR=${WORKDIR}/include
export LIBDIR=${WORKDIR}/lib
export MAKE="make -j2"
export DLDIR=${WORKDIR}/download

#export PATH=/home/buildbot/mxe/usr/bin:$PATH
#export TARGETOS=win32
#export CMAKE=i686-w64-mingw32.static.posix-cmake


echo "WORKDIR:    $WORKDIR"
echo "TMPDIR:     $TMPDIR"
echo "INCLUDEDIR: $INCLUDEDIR"
echo "LIBDIR:     $LIBDIR"
echo "MAKE:       $MAKE"
echo "DLDIR:      $DLDIR"


mkdir -p "${TMPDIR}"
mkdir -p "${INCLUDEDIR}"
mkdir -p "${LIBDIR}"
mkdir -p "${DLDIR}"

function wget {
	URL=$1
	FILENAME=${DLDIR}/$(basename "$URL")
	if ! [ -s "$FILENAME" ]; then
		/usr/bin/wget "$URL" -O "$FILENAME"
	fi

	cd "$(mktemp -d)"
	pwd
	tar xifz "$FILENAME" --strip-components=1
}

