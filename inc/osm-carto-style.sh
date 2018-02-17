#----------------------------------------------------
#
# CartoOsm style sheet - the current OSM default style
#
#----------------------------------------------------

cd /home/maposmatic/styles
git clone https://github.com/gravitystorm/openstreetmap-carto.git
cd openstreetmap-carto
git checkout v3.1.0

ln -s /home/maposmatic/shapefiles data

sed '/\sname:/d' < project.mml > osm.mml
carto -a 3.0.0 osm.mml > osm.xml

# create color-reduced variant of generated style

php /vagrant/files/bw.php

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
 
