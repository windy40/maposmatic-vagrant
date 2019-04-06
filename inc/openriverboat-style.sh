#! /bin/bash

cd /home/maposmatic/styles

git clone https://github.com/yohanboniface/OpenRiverboatMap.git
cd OpenRiverboatMap/openriverboatmap

ln -s /home/maposmatic/shapefiles data

sed -e 's/"dbname": "osm"/"dbname": "gis"/g' \
    -e 's/"host": "localhost"/"host": "gis-db"/g' \
    -e 's/"user": "osm"/"user": "maposmatic"/g' \
    -e 's/"password": "osm"/"password": "secret"/g' \
    -e "s/layer \~/tags->'layer' \~/g" \
    -e 's|http://tilemill-data.s3.amazonaws.com/osm/shoreline_300.zip|data/shoreline_300/shoreline_300.shp|' \
    -e 's|http://mapbox-geodata.s3.amazonaws.com/natural-earth-1.3.0/physical/10m-land.zip|data/ne_10m_land/ne_10m_land.shp|' \
    -e 's|http://tilemill-data.s3.amazonaws.com/osm/coastline-good.zip|data/land-polygons-split-3857/land_polygons.shp|' \
    -e '/"name":/d' \
    < openriverboatmap.mml > processed.mml

carto -q -a $(mapnik-config -v) processed.mml > openriverboatmap.xml


cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[openriverboatmap]
name: OpenRiverboatMap
group: Sports
description: OpenRiverboatMap style 
path: /home/maposmatic/styles/OpenRiverboatMap/openriverboatmap/openriverboatmap.xml

EOF

echo "  openriverboatmap," >> /home/maposmatic/ocitysmap/ocitysmap.styles

