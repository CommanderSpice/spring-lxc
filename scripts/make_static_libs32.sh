#!/bin/bash

source make_static_libs_common.sh

# zlib
wget http://www.zlib.net/zlib-1.2.11.tar.gz
CFLAGS="-fPIC -DPIC -m32" LDFLAGS=-m32 ./configure --prefix ${WORKDIR}
${MAKE}
${MAKE} install

# libpng
wget http://prdownloads.sourceforge.net/libpng/libpng-1.6.34.tar.gz
./configure --enable-static --prefix ${WORKDIR}
${MAKE} -f scripts/makefile.linux CFLAGS="-fPIC -DPIC -m32" LDFLAGS=-m32 ZLIBLIB=${LIBDIR} ZLIBINC=${INCLUDEDIR} prefix=${WORKDIR} libpng.a
${MAKE} -f scripts/makefile.linux prefix=${WORKDIR} install

# libjpeg
wget http://www.ijg.org/files/jpegsrc.v9b.tar.gz
CFLAGS=-m32 LDFLAGS=-m32 ./configure --with-pic --prefix ${WORKDIR} --host=i686-linux-gnu
${MAKE}
${MAKE} install

# libtiff
wget http://download.osgeo.org/libtiff/tiff-4.0.8.tar.gz
CFLAGS=-m32 CXXFLAGS=-m32 LDFLAGS=-m32 ./configure --with-pic --disable-lzma --disable-jbig --prefix ${WORKDIR} --host=i686-linux-gnu
${MAKE}
${MAKE} install

# libIL (DevIL)
wget https://api.github.com/repos/DentonW/DevIL/tarball/e34284a7e07763769f671a74b4fec718174ad862
cmake DevIL -DCMAKE_CXX_FLAGS="-fPIC -m32" -DBUILD_SHARED_LIBS=0 -DCMAKE_INSTALL_PREFIX=${WORKDIR} \
        -DPNG_PNG_INCLUDE_DIR=${INCLUDEDIR} -DPNG_LIBRARY_RELEASE=${LIBDIR}/libpng.a \
        -DJPEG_INCLUDE_DIR=${INCLUDEDIR} -DJPEG_LIBRARY=${LIBDIR}/libjpeg.a \
        -DTIFF_INCLUDE_DIR=${INCLUDEDIR} -DTIFF_LIBRARY_RELEASE=${LIBDIR}/libtiff.a \
        -DZLIB_INCLUDE_DIR=${INCLUDEDIR} -DZLIB_LIBRARY_RELEASE=${LIBDIR}/libz.a
${MAKE}
${MAKE} install

# libunwind
wget http://download.savannah.nongnu.org/releases/libunwind/libunwind-1.2.1.tar.gz
CFLAGS=-m32 CXXFLAGS=-m32 LDFLAGS=-m32 ./configure --with-pic --disable-minidebuginfo --prefix ${WORKDIR} --host=i686-linux-gnu
${MAKE}
${MAKE} install

# glew
wget https://sourceforge.net/projects/glew/files/glew/2.1.0/glew-2.1.0.tgz
${MAKE} GLEW_PREFIX=${WORKDIR} GLEW_DEST=${WORKDIR} LIBDIR=${LIBDIR} CFLAGS.EXTRA=-m32 LDFLAGS.EXTRA=-m32
${MAKE} GLEW_PREFIX=${WORKDIR} GLEW_DEST=${WORKDIR} LIBDIR=${LIBDIR} install
