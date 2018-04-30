#!/bin/sh

set -e

SCRIPT=$(realpath $0)
SCRIPTPATH=$(dirname $SCRIPT)
CFG=$SCRIPTPATH/cfg
LOCAL=$SCRIPTPATH/local
ARCHITECTURES="x64 i386 win32"
#ARCHITECTURES="win32"

for arch in $ARCHITECTURES; do
	b=buildslave-$arch
	echo $b
	cd $CFG
	lxc file push . $b/ -p -r -v
	cd $LOCAL
	lxc file push . $b/ -p -r

	case $arch in
		"x64")
		;;
		"i386")
			lxc exec $b -- /install/setup-linux.sh
			lxc exec $b -- /install/make_static_libs.sh /home/buildbot/lib
			lxc exec $b -- /install/setup-auth.sh
		break
		;;
		"win32")
			lxc exec $b -- /install/install-win32.sh
			lxc exec $b -- /install/install-mxe.sh /home/buildbot
			lxc exec $b -- /install/setup-auth.sh
		break
		;;
		*)
			echo "Unknown arch: $arch"
			exit 1
		break
		;;
	esac
	
	lxc exec $b -- apt clean
	lxc exec $b -- rm -rf /home/buildbot/lib/tmp /home/buildbot/lib/download /install
	lxc exec $b -- systemctl daemon-reload
	lxc exec $b -- systemctl start autossh
	lxc exec $b -- systemctl start buildslave
	lxc exec $b -- chown -R buildbot:buildbot /home/buildbot
done

