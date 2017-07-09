#! /bin/bash

cd /home/maposmatic/styles

git clone https://github.com/yohanboniface/OpenRiverboatMap.git
cd OpenRiverboatMap/openriverboatmap

mkdir data
cd data

wget http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/physical/ne_10m_land.zip
unzip ne_10m_land.zip
for a in ne_10m_land.*
do
  b=$(echo $a | sed -e 's/^ne_10m_/10m-/g')
  ln -s $a $b
done
rm ne_10m_land.zip

wget http://data.openstreetmapdata.com/coastlines-split-3857.zip
unzip coastlines-split-3857.zip
for a in coastlines-split-3857/lines.*
do 
  b=$(echo $a | sed -e 's/lines/coastline-good/g')
  ln -s $a $b
done
rm coastlines-split-3857.zip

wget http://tile.openstreetmap.org/shoreline_300.tar.bz2
tar -xvf shoreline_300.tar.bz2
rm shoreline_300.tar.bz2

cd ..

sed -e 's/"dbname": "osm"/"dbname": "gis"/g' \
    -e 's/"host": "localhost"/"host": "gis-db"/g' \
    -e 's/"user": "osm"/"user": "maposmatic"/g' \
    -e 's/"password": "osm"/"password": "secret"/g' \
    -e 's|http://tilemill-data.s3.amazonaws.com/osm/shoreline_300.zip|data/shoreline_300.shp|' \
    -e 's|http://mapbox-geodata.s3.amazonaws.com/natural-earth-1.3.0/physical/10m-land.zip|data/10m-land.shp|' \
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

