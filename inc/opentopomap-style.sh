#! /bin/bash

cd /home/maposmatic/styles

git clone https://github.com/der-stefan/OpenTopoMap.git

cd OpenTopoMap/mapnik

ln -s ../../mapnik2-osm/world_boundaries .

mkdir -p data 
cd data
wget http://data.openstreetmapdata.com/water-polygons-generalized-3857.zip
unzip water-polygons-generalized-3857.zip
wget http://data.openstreetmapdata.com/water-polygons-split-3857.zip
unzip water-polygons-split-3857.zip
cd ..


