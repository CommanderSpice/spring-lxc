
set -e

if [ "$container" != "lxc" ]; then
        echo "Not running inside lxc container, exiting..."
        exit 1
fi

export WORKDIR=$1
export TMPDIR=${WORKDIR}/tmp
export INCLUDEDIR=${WORKDIR}/include
export LIBDIR=${WORKDIR}/lib
export MAKE="make -j2"
export DLDIR=${WORKDIR}/download

echo WORKDIR:    $WORKDIR
echo TMPDIR:     $TMPDIR
echo INCLUDEDIR: $INCLUDEDIR
echo LIBDIR:     $LIBDIR
echo MAKE:       $MAKE
echo DLDIR:      $DLDIR

mkdir -p ${TMPDIR}
mkdir -p ${INCLUDEDIR}
mkdir -p ${LIBDIR}
mkdir -p ${DLDIR}

function wget {
	URL=$1
	FILENAME=${DLDIR}/$(basename $1)
	if ! [ -s $FILENAME ]; then
		/usr/bin/wget $1 -O $FILENAME
	fi

	cd $(mktemp -d)
	tar xifzv $FILENAME --strip-components=1
}

