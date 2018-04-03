#! /bin/bash

cd /home/maposmatic/styles

git clone https://github.com/yohanboniface/OpenRiverboatMap.git
cd OpenRiverboatMap/openriverboatmap

mkdir data
cd data

for a in shoreline_300 ne_10m_land coastlines-split-3857
do
	ln -s /home/maposmatic/shapefiles/$a .
done

cd ..

sed -e 's/"dbname": "osm"/"dbname": "gis"/g' \
    -e 's/"host": "localhost"/"host": "gis-db"/g' \
    -e 's/"user": "osm"/"user": "maposmatic"/g' \
    -e 's/"password": "osm"/"password": "secret"/g' \
    -e 's|http://tilemill-data.s3.amazonaws.com/osm/shoreline_300.zip|data/shoreline_300/shoreline_300.shp|' \
    -e 's|http://mapbox-geodata.s3.amazonaws.com/natural-earth-1.3.0/physical/10m-land.zip|data/ne_10m_land/ne_10m_land.shp|' \
    -e 's|http://tilemill-data.s3.amazonaws.com/osm/coastline-good.zip|data/coastlines-split-3857/lines.shp|' \
    -e '/"name":/d' \
    -i openriverboatmap.mml

carto openriverboatmap.mml > openriverboatmap.xml


cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[openriverboatmap]
name: OpenRiverboatMap
description: OpenRiverboatMap style 
path: /home/maposmatic/styles/OpenRiverboatMap/openriverboatmap/openriverboatmap.xml

EOF

echo "  openriverboatmap," >> /home/maposmatic/ocitysmap/ocitysmap.styles

