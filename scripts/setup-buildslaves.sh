#!/bin/sh

set -e

SCRIPT=$(realpath $0)
SCRIPTPATH=$(dirname $SCRIPT)
CFG=$SCRIPTPATH/cfg

for arch in x64 i686; do
	b=buildslave-$arch
	echo $b
	cd $CFG
	for i in $(find -type f);
	do
		echo lxc file push $i $b/$i
		lxc file push $i $b/$i -p
	done
	lxc exec $b -- /home/buildslave/scripts/setup-buildslave.sh
	lxc exec $b -- /home/buildslave/scripts/make_static_libs.sh
	echo lxc exec $b -- /home/buildslave/scripts/setup-auth.sh
	lxc exec $b -- /home/buildslave/scripts/setup-auth.sh
	lxc exec $b -- apt clean
done

