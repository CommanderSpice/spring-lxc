#!/bin/bash

set -e
source $(dirname $0)/make_static_libs_common.sh

# zlib https://zlib.net/
wget https://www.zlib.net/zlib-1.2.13.tar.gz
if [ "${TARGETOS}" = "win32" ]; then
	${MAKE} -f win32/Makefile.gcc PREFIX=i686-w64-mingw32.static.posix-
	${MAKE} -f win32/Makefile.gcc PREFIX=i686-w64-mingw32.static.posix- INCLUDE_PATH=${WORKDIR}/include LIBRARY_PATH=${WORKDIR}/lib BINARY_PATH=${WORKDIR}/bin  install
else
	CFLAGS="-fPIC" ./configure --prefix ${WORKDIR}
	${MAKE}
	${MAKE} install
fi

# libpng http://www.libpng.org/pub/png/libpng.html
wget https://prdownloads.sourceforge.net/libpng/libpng-1.6.39.tar.gz
if [ "${TARGETOS}" = "win32" ]; then
	 ./configure --host=i686-w64-mingw32.static.posix
	${MAKE}
	${MAKE} prefix=${WORKDIR} install
else
	cmake . -DZLIB_LIBRARY=${LIBDIR}/libz.a -DZLIB_INCLUDE_DIR=${INCLUDEDIR} -DCMAKE_INSTALL_PREFIX=${WORKDIR} -DPNG_SHARED=OFF -DPNG_TESTS=OFF
	make install
fi

# libjpeg https://www.ijg.org/
wget http://www.ijg.org/files/jpegsrc.v9e.tar.gz
if [ "${TARGETOS}" = "win32" ]; then
	./configure --with-pic --prefix ${WORKDIR} --host=i686-w64-mingw32.static.posix
else
	./configure --with-pic --prefix ${WORKDIR}
fi
${MAKE}
${MAKE} install

# libtiff https://download.osgeo.org/libtiff/
wget https://download.osgeo.org/libtiff/tiff-4.5.0.tar.gz
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
	cmake  DevIL -DCMAKE_CXX_FLAGS=-fPIC -DBUILD_SHARED_LIBS=0 -DCMAKE_INSTALL_PREFIX=${WORKDIR} \
	        -DPNG_PNG_INCLUDE_DIR=${INCLUDEDIR} -DPNG_LIBRARY_RELEASE=${LIBDIR}/libpng.a \
	        -DJPEG_INCLUDE_DIR=${INCLUDEDIR} -DJPEG_LIBRARY=${LIBDIR}/libjpeg.a \
	        -DTIFF_INCLUDE_DIR=${INCLUDEDIR} -DTIFF_LIBRARY_RELEASE=${LIBDIR}/libtiff.a \
	        -DZLIB_INCLUDE_DIR=${INCLUDEDIR} -DZLIB_LIBRARY_RELEASE=${LIBDIR}/libz.a \
		-DGLUT_INCLUDE_DIR=${INCLUDEDIR}
fi
${MAKE}
${MAKE} install


# libunwind https://github.com/libunwind/libunwind/releases/
if [ ! "${TARGETOS}" = "win32" ]; then
	wget https://github.com/libunwind/libunwind/releases/download/v1.6.2/libunwind-1.6.2.tar.gz
	CFLAGS="${CFLAGS} -fcommon" ./configure --with-pic --disable-minidebuginfo --prefix ${WORKDIR}
	${MAKE}
	${MAKE} install
fi

# glew https://github.com/nigels-com/glew/releases/
wget https://github.com/nigels-com/glew/releases/download/glew-2.2.0/glew-2.2.0.tgz
if [ "${TARGETOS}" = "win32" ]; then
	${MAKE} GLEW_PREFIX=${WORKDIR} GLEW_DEST=${WORKDIR} LIBDIR=${LIBDIR} SYSTEM=linux-mingw32 HOST=i686-w64-mingw32.static.posix
	${MAKE} GLEW_PREFIX=${WORKDIR} GLEW_DEST=${WORKDIR} LIBDIR=${LIBDIR} SYSTEM=linux-mingw32 install
else
	${MAKE} GLEW_PREFIX=${WORKDIR} GLEW_DEST=${WORKDIR} LIBDIR=${LIBDIR}
	${MAKE} GLEW_PREFIX=${WORKDIR} GLEW_DEST=${WORKDIR} LIBDIR=${LIBDIR} install

fi

# openssl https://www.openssl.org/source/
wget https://www.openssl.org/source/openssl-3.0.7.tar.gz
./config no-ssl2 no-ssl3 no-comp no-shared no-dso no-weak-ssl-ciphers no-tests no-deprecated --prefix=${WORKDIR} --libdir=${LIBDIR}
${MAKE}
${MAKE} install_sw

# curl https://curl.se/download.html
wget https://curl.se/download/curl-7.87.0.tar.gz
./configure --with-pic --disable-shared --disable-manual --disable-dict --disable-file --disable-ftp --disable-ftps --disable-gopher --disable-imap --disable-imaps --disable-pop3 --disable-pop3s --disable-rtsp --disable-smb --disable-smbs --disable-smtp --disable-smtps --disable-telnet --disable-tftp --disable-unix-sockets --without-brotli --disable-ntlm-wb --disable-ntlm --with-ssl=${WORKDIR} --prefix ${WORKDIR}
${MAKE}
${MAKE} install

# fontconfig https://www.freedesktop.org/software/fontconfig/release/
wget https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.14.1.tar.gz
./configure --with-pic --disable-shared  --disable-docs --prefix=${WORKDIR} --with-sysroot=${LIBDIR}
${MAKE} install

# freetype https://sourceforge.net/projects/freetype/files/freetype2/
wget https://prdownloads.sourceforge.net/freetype/freetype-2.12.1.tar.gz
./configure --with-pic --disable-shared --without-brotli --prefix=${WORKDIR} --with-sysroot=${LIBDIR}
${MAKE} install

# libgit2 https://github.com/libgit2/libgit2/releases
wget https://github.com/libgit2/libgit2/archive/refs/tags/v1.5.0.tar.gz
cmake . -DUSE_SSH=FALSE \
	-DUSE_HTTPS=OFF \
	-DBUILD_TESTS=OFF \
	-DBUILD_CLI=OFF \
	-DBUILD_SHARED_LIBS=FALSE \
	-DUSE_NTLMCLIENT=FALSE \
	-DZLIB_LIBRARY_RELEASE=${LIBDIR}/libz.a -DZLIB_INCLUDE_DIR=${INCLUDEDIR} \
	-DCMAKE_INSTALL_PREFIX=${WORKDIR}
make install
