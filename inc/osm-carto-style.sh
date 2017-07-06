#----------------------------------------------------
#
# CartoOsm style sheet - the current OSM default style
#
#----------------------------------------------------

cd /home/maposmatic/styles
git clone https://github.com/gravitystorm/openstreetmap-carto.git
cd openstreetmap-carto
git checkout v3.1.0
./scripts/get-shapefiles.py
carto -a 3.0.0 project.mml > osm.xml

# create color-reduced variant of generated style

php /vagrant/files/bw.php

# add extra shape file needed by other carto based styles later
cd data
wget http://data.openstreetmapdata.com/simplified-land-polygons-complete-3857.zip
unzip simplified-land-polygons-complete-3857.zip
wget http://data.openstreetmapdata.com/land-polygons-split-3857.zip
unzip land-polygons-split-3857.zip
mkdir ne_10m_populated_places
cd ne_10m_populated_places
wget http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_populated_places.zip
unzip ne_10m_populated_places.zip
ogr2ogr --config SHAPE_ENCODING UTF8 ne_10m_populated_places_fixed.shp ne_10m_populated_places.shp



cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[cartoosm]
name: CartoOSM
description: Current CartoCSS OSM style
path: /home/maposmatic/styles/openstreetmap-carto/osm.xml

[cartobw]
name: CartoOsmBW
description: B&W Variant of CartoCSS OSM style
path: /home/maposmatic/styles/openstreetmap-carto/osm-bw.xml

EOF

echo "  cartoosm," >> /home/maposmatic/ocitysmap/ocitysmap.styles
echo "  cartobw," >> /home/maposmatic/ocitysmap/ocitysmap.styles
 
