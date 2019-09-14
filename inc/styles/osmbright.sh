#! /bin/bash

cd /home/maposmatic/styles

git clone --quiet https://github.com/mapbox/osm-bright.git

cd osm-bright

ln -s /home/maposmatic/shapefiles shp

cp /vagrant/files/osmbright-configure.py configure.py

./make.py

cd OSMBright
sed '/"name":/d' < project.mml > osm.mml
carto -q -a $(mapnik-config -v) osm.mml  > osm.xml

