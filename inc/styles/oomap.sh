#! /bin/bash

cd /home/maposmatic/styles

git clone https://github.com/oobrien/oomap

cd oomap/maptiler/d$styles

cp /vagrant/files/stles/oomap/* styles/inc/

ln -s /home/maposmatic/shapefiles



