#!/bin/sh

set -e

SCRIPT=$(realpath $0)
SCRIPTPATH=$(dirname $SCRIPT)
CFG=$SCRIPTPATH/cfg

for arch in x64 i686; do
	b=buildslave-$arch
	echo $b
	lxc file push $CFG $b/ -p -r
	lxc exec $b -- /home/buildslave/scripts/setup-buildslave.sh
	lxc exec $b -- /home/buildslave/scripts/make_static_libs.sh
	lxc exec $b -- /home/buildslave/scripts/setup-auth.sh
	lxc exec $b -- apt clean
done

