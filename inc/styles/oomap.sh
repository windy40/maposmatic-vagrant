#! /bin/bash

cd /home/maposmatic/styles

git clone https://github.com/oobrien/oomap

cd oomap/maptiler/

cp /vagrant/files/styles/oomap/* styles/inc/

ln -s /home/maposmatic/shapefiles .



