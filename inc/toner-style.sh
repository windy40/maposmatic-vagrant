#! /bin/bash

cd /home/maposmatic/styles

git clone https://github.com/geofabrik/toner.git

cd toner

ln -s toner.mml project.mml

rm -rf data
ln -s /home/maposmatic/shapefiles data

carto -a $(mapnik-config -v) toner.mml | php /vagrant/files/fontsplit.php  > toner.xml

sudo -u maposmatic psql gis < sql/functions/highroad.sql 

cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[toner]
name: Toner
description: Toner style by Stamen / GeoFabrik
path: /home/maposmatic/styles/toner/toner.xml
annotation: Toner style © Stamen, Geofabrik
url: http://www.osm-baustelle.de/dokuwiki/style:toner

EOF

echo "  toner," >> /home/maposmatic/ocitysmap/ocitysmap.styles


