#!/bin/bash

set -e
source $(dirname $0)/make_static_libs_common.sh

if [ -z "$1" ]; then
        echo "Missing destination dir. usage: $0 <destdir>"
        exit 1
fi

mkdir -p $1

# zlib
wget https://www.zlib.net/zlib-1.2.11.tar.gz
CFLAGS="-fPIC" ./configure --prefix ${WORKDIR}
${MAKE}
${MAKE} install

# libpng
wget https://prdownloads.sourceforge.net/libpng/libpng-1.6.37.tar.gz
#./configure --enable-static --prefix ${WORKDIR}
${MAKE} -f scripts/makefile.linux CFLAGS="-fPIC -DPIC" ZLIBLIB=${LIBDIR} ZLIBINC=${INCLUDEDIR} prefix=${WORKDIR}
${MAKE} -f scripts/makefile.linux prefix=${WORKDIR} install

# libjpeg
wget https://www.ijg.org/files/jpegsrc.v9c.tar.gz
./configure --with-pic --prefix ${WORKDIR}
${MAKE}
${MAKE} install

# libtiff
wget https://download.osgeo.org/libtiff/tiff-4.0.8.tar.gz
./configure --with-pic --disable-lzma --disable-jbig --prefix ${WORKDIR}
${MAKE}
${MAKE} install


# libIL (DevIL)
wget https://api.github.com/repos/spring/DevIL/tarball/ee8e056bdd27d93ccc57da423f2e939c336630d4
cmake DevIL -DCMAKE_CXX_FLAGS=-fPIC -DBUILD_SHARED_LIBS=0 -DCMAKE_INSTALL_PREFIX=${WORKDIR} \
        -DPNG_PNG_INCLUDE_DIR=${INCLUDEDIR} -DPNG_LIBRARY_RELEASE=${LIBDIR}/libpng.a \
        -DJPEG_INCLUDE_DIR=${INCLUDEDIR} -DJPEG_LIBRARY=${LIBDIR}/libjpeg.a \
        -DTIFF_INCLUDE_DIR=${INCLUDEDIR} -DTIFF_LIBRARY_RELEASE=${LIBDIR}/libtiff.a \
        -DZLIB_INCLUDE_DIR=${INCLUDEDIR} -DZLIB_LIBRARY_RELEASE=${LIBDIR}/libz.a
${MAKE}
${MAKE} install

# libunwind
wget https://download.savannah.nongnu.org/releases/libunwind/libunwind-1.2.1.tar.gz
./configure --with-pic --disable-minidebuginfo --prefix ${WORKDIR}
${MAKE}
${MAKE} install

# glew
wget https://sourceforge.net/projects/glew/files/glew/2.1.0/glew-2.1.0.tgz
${MAKE} GLEW_PREFIX=${WORKDIR} GLEW_DEST=${WORKDIR} LIBDIR=${LIBDIR}
${MAKE} GLEW_PREFIX=${WORKDIR} GLEW_DEST=${WORKDIR} LIBDIR=${LIBDIR} install

# openssl
wget https://www.openssl.org/source/openssl-1.1.1c.tar.gz
./config no-ssl3 no-comp no-shared no-dso no-weak-ssl-ciphers no-tests no-deprecated --prefix=${WORKDIR}
${MAKE}
${MAKE} install_sw


# curl
wget https://curl.haxx.se/download/curl-7.65.3.tar.gz
./configure --with-pic --disable-shared --disable-manual --disable-dict --disable-file --disable-ftp --disable-ftps --disable-gopher --disable-imap --disable-imaps --disable-pop3 --disable-pop3s --disable-rtsp --disable-smb --disable-smbs --disable-smtp --disable-smtps --disable-telnet --disable-tftp --disable-unix-sockets --with-ssl=${WORKDIR} --prefix ${WORKDIR}
${MAKE}
${MAKE} install
