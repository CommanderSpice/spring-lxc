#!/bin/sh

set -e

SCRIPT=$(realpath $0)
SCRIPTPATH=$(dirname $SCRIPT)
CFG=$SCRIPTPATH/cfg

for arch in x64 i686; do
	b=buildslave-$arch
	echo $b
	cd $CFG
	lxc file push . $b/ -p -r
	lxc exec $b -- /home/buildbot/scripts/setup-buildslave.sh
	lxc exec $b -- /home/buildbot/scripts/make_static_libs.sh
	lxc exec $b -- /home/buildbot/scripts/setup-auth.sh
	lxc exec $b -- apt clean
	lxc exec $b -- systemctl daemon-reload
	lxc exec $b -- systemctl start autossh
	lxc exec $b -- systemctl start buildslave
done

