#!/bin/sh

set -e

SCRIPT=$(realpath $0)
SCRIPTPATH=$(dirname $SCRIPT)
CFG=$SCRIPTPATH/cfg
LOCAL=$SCRIPTPATH/local

for arch in x64 i686; do
	b=buildslave-$arch
	echo $b
	cd $CFG
	lxc file push . $b/ -p -r
	cd $LOCAL
	lxc file push . $b/ -p -r
	lxc exec $b -- /home/buildbot/scripts/setup-buildslave.sh
	lxc exec $b -- /home/buildbot/scripts/make_static_libs.sh /home/buildbot/lib
	lxc exec $b -- /home/buildbot/scripts/setup-auth.sh
	lxc exec $b -- apt clean
	lxc exec $b -- rm -rf /home/buildbot/lib/tmp /home/buildbot/lib/download
	lxc exec $b -- systemctl daemon-reload
	lxc exec $b -- systemctl start autossh
	lxc exec $b -- systemctl start buildslave
	lxc exec $b -- chown -R buildbot:buildbot /home/buildbot
done

