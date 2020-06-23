#! /bin/bash

cd /etc/munin

cp /vagrant/files/munin/* plugins/

sed -i -e's/Require local/Require all granted/g' apache24.conf

systemctl restart apache2 munin-node
