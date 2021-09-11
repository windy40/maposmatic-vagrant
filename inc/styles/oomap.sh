#! /bin/bash

cd /home/maposmatic/styles

git clone https://github.com/hholzgra/oomap

cd oomap/

git checkout maposmatic

cd maptiler/

cp /vagrant/files/styles/oomap/* styles/inc/

ln -s /home/maposmatic/shapefiles .

psql gis < /vagrant/inc/styles/oomap.sql
shp2pgsql -g way /home/maposmatic/shapefiles/water-polygons-split-3857/water_polygons.shp public.water | psql gis > /dev/null
