#! /bin/bash

cat $FILEDIR/config-files/renderd.conf >> /etc/renderd.conf

mkdir -p /var/lib/mod_tile/osmcarto
chown _renderd /var/lib/mod_tile/osmcarto

sudo -u postgres createuser -g maposmatic _renderd

systemctl restart renderd apache2
