#! /bin/bash

cd /home/maposmatic/styles

git clone https://github.com/mapbox/osm-bright.git

cd osm-bright

mkdir shp

cd shp

wget http://data.openstreetmapdata.com/simplified-land-polygons-complete-3857.zip
unzip simplified-land-polygons-complete-3857.zip
cd simplified-land-polygons-complete-3857
shapeindex simplified_land_polygons.shp
cd ..

wget http://data.openstreetmapdata.com/land-polygons-split-3857.zip
unzip land-polygons-split-3857.zip
cd land-polygons-split-3857
shapeindex land_polygons.shp
cd ..

mkdir 10m-populated-places-simple
cd 10m-populated-places-simple
wget http://mapbox-geodata.s3.amazonaws.com/natural-earth-1.4.0/cultural/10m-populated-places-simple.zip
unzip 10m-populated-places-simple.zip
shapeindex 10m-populated-places-simple.shp
cd ..

cd ..

cp /vagrant/files/configure.py .

./make.py

cd OSMBright
carto project.mml  > osm.xml

cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[osmbright]
name: OsmBright
description: Mapbox OSM Bright style
path: /home/maposmatic/styles/osm-bright/OSMBright/osm.xml

EOF

echo "  osmbright," >> /home/maposmatic/ocitysmap/ocitysmap.styles

