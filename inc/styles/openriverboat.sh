#! /bin/bash

cd /home/maposmatic/styles

git clone --quiet https://github.com/yohanboniface/OpenRiverboatMap.git

cd OpenRiverboatMap

ln -s /home/maposmatic/shapefiles data

sed -e 's/dbname: osm/dbname: gis/g' \
    -e "s/host: ''/host: gis-db/g" \
    -e 's/user: ybon/user: maposmatic/g' \
    -e 's/password: null/password: secret/g' \
    -e "s/layer \~/tags->'layer' \~/g" \
    -e 's|https://osmdata.openstreetmap.de/download/simplified-land-polygons-complete-3857.zip|data/simplified-land-polygons-complete-3857/simplified_land_polygons.shp|' \
    -e 's|https://osmdata.openstreetmap.de/download/land-polygons-split-3857.zip|data/land-polygons-split-3857/land_polygons.shp|' \
    -e '/"name":/d' \
    < project.yml > processed.mml

carto -q -a $(mapnik-config -v) processed.mml > openriverboatmap.xml

