#! /bin/bash

cd $STYLEDIR

git clone https://github.com/hholzgra/oomap

cd oomap/

git checkout maposmatic

cd maptiler/

cp $FILEDIR/styles/oomap/* styles/inc/

ln -s $SHAPEFILE_DIR .

psql gis < $INCDIR/styles/oomap.sql
shp2pgsql -g way $SHAPEFILE_DIR/water-polygons-split-3857/water_polygons.shp public.water | psql gis > /dev/null
