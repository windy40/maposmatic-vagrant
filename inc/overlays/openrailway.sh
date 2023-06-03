#! /bin/bash

cd $STYLEDIR

git clone --quiet https://github.com/OpenRailwayMap/OpenRailwayMap-CartoCSS

cd OpenRailwayMap-CartoCSS

for carto_style in *.mml
do
	mapnik_style=$(basename $carto_style .mml).xml
	carto --quiet --api $MAPNIK_VERSION_FOR_CARTO $carto_style  > $mapnik_style
        php $FILEDIR/tools/postprocess-style.php $mapnik_style
done


