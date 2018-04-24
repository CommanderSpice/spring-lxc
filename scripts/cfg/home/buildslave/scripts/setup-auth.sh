#!/bin/bash

set -e

BUILDBOTDIR=/home/buildslave

rm -rf "$BUILDBOTDIR/.ssh"
mkdir -p "$BUILDBOTDIR/.ssh"


PASSWORD=$(pwgen 64 1)

buildslave create-slave "$BUILDBOTDIR" localhost:9999 "$HOSTNAME" "$PASSWORD"a
ssh-keygen -q -t rsa -N "" -f "$BUILDBOTDIR/.ssh/id_rsa"

chmod 700 "$BUILDBOTDIR/.ssh"
chown -R buildbot:buildbot $BUILDBOTDIR

systemctl enable /etc/systemd/system/autossh.service

echo "Public key:"
cat "$BUILDBOTDIR/.ssh/id_rsa.pub"
echo "buildslave username: $HOSTNAME password: $PASSWORD"

