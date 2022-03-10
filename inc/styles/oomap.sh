#! /bin/bash

cd /home/maposmatic/styles

git clone https://github.com/hholzgra/oomap

cd oomap/

git checkout maposmatic

cd maptiler/

cp $FILEDIR/styles/oomap/* styles/inc/

ln -s /home/maposmatic/shapefiles .

psql gis < $INCDIR/styles/oomap.sql
shp2pgsql -g way /home/maposmatic/shapefiles/water-polygons-split-3857/water_polygons.shp public.water | psql gis > /dev/null
