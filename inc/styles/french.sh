#! /bin/bash

cd /home/maposmatic/styles

git clone --quiet https://github.com/cquest/osmfr-cartocss.git
cd osmfr-cartocss
git checkout --quiet v2.8.0

ln -s /home/maposmatic/shapefiles data

sed '/"name":/d' < project.mml > osm.mml
carto -q -a $(mapnik-config -v) osm.mml > osm.xml

