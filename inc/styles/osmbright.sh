#! /bin/bash

cd /home/maposmatic/styles

git clone --quiet https://github.com/hholzgra/osm-bright.git

cd osm-bright

ln -s /home/maposmatic/shapefiles shp

cp $FILEDIR/config-files/osmbright-configure.py configure.py

./make.py

cd OSMBright
sed '/"name":/d' < project.mml > osm.mml
carto -q -a $(mapnik-config -v) osm.mml  > osm.xml

