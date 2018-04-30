#!/bin/bash

set -e

BUILDBOTDIR=/home/buildbot
BUILDSLAVECFG=$BUILDBOTDIR/buildbot.tac

usermod -d "$BUILDBOTDIR" buildbot
rm -rf "$BUILDBOTDIR/.ssh"
mkdir -p "$BUILDBOTDIR/.ssh"



if [ -s $BUILDSLAVECFG ]; then
	PASSWORD=$(grep password $BUILDSLAVECFG)
else
	PASSWORD=$(pwgen 64 1)
	buildslave create-slave "$BUILDBOTDIR" localhost:9999 "$HOSTNAME" "$PASSWORD"
fi

if ! [ -s "$BUILDBOTDIR/.ssh/id_rsa" ]; then
	ssh-keygen -q -t rsa -N "" -f "$BUILDBOTDIR/.ssh/id_rsa"
fi

chmod 700 "$BUILDBOTDIR/.ssh"
chown -R buildbot:buildbot $BUILDBOTDIR

systemctl enable /etc/systemd/system/autossh.service

echo "Public key:"
cat "$BUILDBOTDIR/.ssh/id_rsa.pub"
echo "buildslave username: $HOSTNAME password: $PASSWORD"

