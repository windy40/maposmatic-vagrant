#! /bin/bash

cd $STYLEDIR

git clone https://github.com/hholzgra/oomap

cd oomap/

git checkout maposmatic

cd maptiler/

for file in $FILEDIR/styles/oomap/*
do
	sed -e "s/@STYLEDIR@/$STYLEDIR/g" < $file > styles/inc/$(basename $file)
done

ln -s $SHAPEFILE_DIR .

psql gis < $INCDIR/styles/oomap.sql
shp2pgsql -g way $SHAPEFILE_DIR/water-polygons-split-3857/water_polygons.shp public.water | psql gis > /dev/null
