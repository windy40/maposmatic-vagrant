#----------------------------------------------------
#
# CartoOsm style sheet - the current OSM default style
#
#----------------------------------------------------

cd /home/maposmatic/styles
git clone https://github.com/gravitystorm/openstreetmap-carto.git
cd openstreetmap-carto
git checkout v4.21.0

ln -s /home/maposmatic/shapefiles data

sed '/\sname:/d' < project.mml > osm.mml
carto -a $(mapnik-config -v) --quiet osm.mml > osm.xml
php /vagrant/files/postprocess-style.php osm.xml

# create color-reduced variant of generated style

php /vagrant/files/bw.php

cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[cartoosm]
name: CartoOSM
description: Current CartoCSS OSM style
path: /home/maposmatic/styles/openstreetmap-carto/osm.xml
url: http://www.osm-baustelle.de/dokuwiki/style:cartoosm
annotation: OpenStreetMap Carto standard style

[cartobw]
name: CartoOsmBW
description: B&W Variant of CartoCSS OSM style
group: Black and White
path: /home/maposmatic/styles/openstreetmap-carto/osm-bw.xml
url: http://www.osm-baustelle.de/dokuwiki/style:cartoosm
annotation: OpenStreetMap Carto with colors reduced to grayscale

EOF

echo "  cartoosm," >> /home/maposmatic/ocitysmap/ocitysmap.styles
echo "  cartobw," >> /home/maposmatic/ocitysmap/ocitysmap.styles
 
