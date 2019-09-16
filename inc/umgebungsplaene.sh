#! /bin/bash

cd /home/maposmatic
git clone --quiet https://github.com/hholzgra/umgebungsplaene
cp /vagrant/files/config-files/umgebungsplaene-config.php config.php
cd umgebungsplaene/www
npm install
