#!/bin/sh

set -e

SCRIPT=$(realpath $0)
SCRIPTPATH=$(dirname $SCRIPT)
CFG=$SCRIPTPATH/cfg

for b in buildslave-x64 buildslave-i686; do
	cd $CFG
	for i in $(find -type f);
	do
		echo lxc file push $i $b/$i
		lxc file push $i $b/$i -p
	done
	#lxc exec $b -- git clone https://github.com/spring/spring-lxc /home/builslave/spring-lxc
	#lxc exec $b -- /home/buildslave/scripts/setup-buildslave.sh
	lxc exec $b -- /home/buildslave/scripts/make_static_libs.sh
done

