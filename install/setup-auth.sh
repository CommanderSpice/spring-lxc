#!/bin/bash

set -e

BUILDBOTDIR=/home/buildbot
CONFIGDIR=/var/lib/buildbot/workers/spring
BUILDSLAVECFG=$CONFIGDIR/buildbot.tac

usermod -d "$BUILDBOTDIR" buildbot

rm -rf "$BUILDBOTDIR/.ssh"
mkdir -p "$BUILDBOTDIR/.ssh"



if [ -s $BUILDSLAVECFG ]; then
	PASSWORD=$(grep "passwd =" $BUILDSLAVECFG | sed -n -e "s/passwd = '\(.*\)'/\1/p")
else
	PASSWORD=$(pwgen 64 1)
	buildbot-worker create-worker "$CONFIGDIR" localhost:9999 "$HOSTNAME" "$PASSWORD"
fi

if ! [ -s "$BUILDBOTDIR/.ssh/id_rsa" ]; then
	ssh-keygen -q -t rsa -N "" -f "$BUILDBOTDIR/.ssh/id_rsa"
fi

chmod 700 "$BUILDBOTDIR/.ssh"
chown -R buildbot:buildbot $BUILDBOTDIR

systemctl enable /etc/systemd/system/autossh.service
systemctl enable buildbot-worker@spring.service

echo -n "Public key: ssh-rsa "
cat "$BUILDBOTDIR/.ssh/id_rsa.pub"
echo "buildslave username: $HOSTNAME password: $PASSWORD"

