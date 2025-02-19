#!/bin/bash

set -e

cd "$1"

COMMIT=0dcf498f9563fd35eff0273e1b56929fdce60383

if [ -x mxe/usr/bin/i686-w64-mingw32.static.posix-cmake ]; then
	echo mxe g++ already exists, skipping!
	exit 0
fi

if [ ! -d mxe ]; then
	git clone https://github.com/mxe/mxe.git
	cd mxe
else
	cd mxe
	git fetch origin
	git clean -f -d -x
fi


git reset --hard $COMMIT

cat << EOF > settings.mk
JOBS := 2
MXE_TARGETS := i686-w64-mingw32.static.posix
LOCAL_PKG_LIST := cc cmake-conf boost # curl sdl2 glew freetype devil vorbis openal add giflib openssl
.DEFAULT_GOAL  := local-pkg-list
local-pkg-list: $(LOCAL_PKG_LIST)
EOF

make
