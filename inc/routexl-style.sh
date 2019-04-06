#! /bin/bash

cd /home/maposmatic/styles

git clone https://github.com/routexl/osm-routexl
cd osm-routexl

ln -s $(realpath ../osm-bright/OSMBright/img) .

sed '/"name":/d' < ../osm-bright/OSMBright/project.mml > osm.mml
sed -ie 's/"dbname": "osm"/"dbname": "gis"/g' osm.mml
sed -ie 's/http.*10m-land.zip"/\/home\/maposmatic\/shapefiles\/ne_10m_land\/ne_10m_land.shp", "type": "shape"/' osm.mml
sed -ie 's/http.*coastline-good.zip"/\/home\/maposmatic\/shapefiles\/land-polygons-split-3857\/land_polygons.shp", "type": "shape"/' osm.mml
sed -ie 's/http.*shoreline_300.zip"/\/home\/maposmatic\/shapefiles\/shoreline_300\/shoreline_300.shp", "type": "shape"/' osm.mml
sed -ie 's/http.*10m-populated-places-simple.zip"/\/home\/maposmatic\/shapefiles\/ne_10m_populated_places_simple\/ne_10m_populated_places_simple.shp", "type": "shape"/' osm.mml
sed -ie 's/"srs": ""/"srs": "+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0.0 +k=1.0 +units=m +nadgrids=@null +wktext +no_defs +over"/g' osm.mml

carto -a $(mapnik-config -v) -q osm.mml  > osm.xml
php /vagrant/files/postprocess-style.php osm.xml

cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[routexl]
name: RouteXL
description: OSM RouteXL style
group: Low Contrast
path: /home/maposmatic/styles/osm-routexl/osm.xml

EOF

echo "  routexl," >> /home/maposmatic/ocitysmap/ocitysmap.styles

