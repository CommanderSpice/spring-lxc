#!/bin/bash

set -e
source $(dirname $0)/make_static_libs_common.sh

# zlib
wget https://www.zlib.net/zlib-1.2.11.tar.gz
if [ "${TARGETOS}" = "win32" ]; then
	${MAKE} -f win32/Makefile.gcc PREFIX=i686-w64-mingw32.static.posix-
	${MAKE} -f win32/Makefile.gcc PREFIX=i686-w64-mingw32.static.posix- INCLUDE_PATH=${WORKDIR}/include LIBRARY_PATH=${WORKDIR}/lib BINARY_PATH=${WORKDIR}/bin  install
else
	CFLAGS="-fPIC" ./configure --prefix ${WORKDIR}
	${MAKE}
	${MAKE} install
fi

# libpng
wget https://prdownloads.sourceforge.net/libpng/libpng-1.6.34.tar.gz
if [ "${TARGETOS}" = "win32" ]; then
	 ./configure --host=i686-w64-mingw32.static.posix
	${MAKE}
	${MAKE} prefix=${WORKDIR} install
else
	${MAKE} -f scripts/makefile.linux CFLAGS="-fPIC -DPIC" ZLIBLIB=${LIBDIR} ZLIBINC=${INCLUDEDIR} prefix=${WORKDIR}
	${MAKE} -f scripts/makefile.linux prefix=${WORKDIR} install
fi

# libjpeg
wget http://www.ijg.org/files/jpegsrc.v9b.tar.gz
if [ "${TARGETOS}" = "win32" ]; then
	./configure --with-pic --prefix ${WORKDIR} --host=i686-w64-mingw32.static.posix
else
	./configure --with-pic --prefix ${WORKDIR}
fi
${MAKE}
${MAKE} install

# libtiff
wget https://download.osgeo.org/libtiff/tiff-4.0.8.tar.gz
if [ "${TARGETOS}" = "win32" ]; then
	./configure --with-pic --disable-lzma --disable-jbig --prefix ${WORKDIR} --host=i686-w64-mingw32.static.posix
else
	./configure --with-pic --disable-lzma --disable-jbig --prefix ${WORKDIR}
fi
${MAKE}
${MAKE} install

# libIL (DevIL)
wget https://api.github.com/repos/spring/DevIL/tarball/d46aa9989f502b89de06801925d20e53d220c1b4
if [ "${TARGETOS}" = "win32" ]; then
	${CMAKE} DevIL -DCMAKE_CXX_FLAGS=-fPIC -DCMAKE_INSTALL_PREFIX=${WORKDIR} \
	        -DPNG_PNG_INCLUDE_DIR=${INCLUDEDIR} -DPNG_LIBRARY_RELEASE=${LIBDIR}/libpng.a \
	        -DJPEG_INCLUDE_DIR=${INCLUDEDIR} -DJPEG_LIBRARY=${LIBDIR}/libjpeg.a \
	        -DTIFF_INCLUDE_DIR=${INCLUDEDIR} -DTIFF_LIBRARY_RELEASE=${LIBDIR}/libtiff.a \
	        -DZLIB_INCLUDE_DIR=${INCLUDEDIR} -DZLIB_LIBRARY_RELEASE=${LIBDIR}/libz.a \
		-DGLUT_INCLUDE_DIR=${INCLUDEDIR} \
		-DBUILD_STATIC=OFF \
		-DBUILD_STATIC_LIBS=OFF \
		-DBUILD_SHARED_LIBS=ON \
		-DBUILD_SHARED=ON 

else
${CMAKE} DevIL -DCMAKE_CXX_FLAGS=-fPIC -DBUILD_SHARED_LIBS=0 -DCMAKE_INSTALL_PREFIX=${WORKDIR} \
	        -DPNG_PNG_INCLUDE_DIR=${INCLUDEDIR} -DPNG_LIBRARY_RELEASE=${LIBDIR}/libpng.a \
	        -DJPEG_INCLUDE_DIR=${INCLUDEDIR} -DJPEG_LIBRARY=${LIBDIR}/libjpeg.a \
	        -DTIFF_INCLUDE_DIR=${INCLUDEDIR} -DTIFF_LIBRARY_RELEASE=${LIBDIR}/libtiff.a \
	        -DZLIB_INCLUDE_DIR=${INCLUDEDIR} -DZLIB_LIBRARY_RELEASE=${LIBDIR}/libz.a \
		-DGLUT_INCLUDE_DIR=${INCLUDEDIR}
fi
${MAKE}
${MAKE} install


# libunwind
if [ ! "${TARGETOS}" = "win32" ]; then
	wget https://download.savannah.nongnu.org/releases/libunwind/libunwind-1.2.1.tar.gz
	./configure --with-pic --disable-minidebuginfo --prefix ${WORKDIR}
	${MAKE}
	${MAKE} install
fi

# glew
wget https://sourceforge.net/projects/glew/files/glew/2.1.0/glew-2.1.0.tgz
if [ "${TARGETOS}" = "win32" ]; then
	${MAKE} GLEW_PREFIX=${WORKDIR} GLEW_DEST=${WORKDIR} LIBDIR=${LIBDIR} SYSTEM=linux-mingw32 HOST=i686-w64-mingw32.static.posix
	${MAKE} GLEW_PREFIX=${WORKDIR} GLEW_DEST=${WORKDIR} LIBDIR=${LIBDIR} SYSTEM=linux-mingw32 install
else
	${MAKE} GLEW_PREFIX=${WORKDIR} GLEW_DEST=${WORKDIR} LIBDIR=${LIBDIR}
	${MAKE} GLEW_PREFIX=${WORKDIR} GLEW_DEST=${WORKDIR} LIBDIR=${LIBDIR} install

fi
