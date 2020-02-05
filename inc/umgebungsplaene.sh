#! /bin/bash

cd /home/maposmatic
git clone --quiet https://github.com/hholzgra/umgebungsplaene
cp /vagrant/files/config-files/umgebungsplaene-config.php config.php
cd umgebungsplaene/www
HOME=/root SUDO_USER=root SUDO_UID=0 SUDO_GID=0 npm install
