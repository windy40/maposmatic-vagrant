#! /bin/bash

cd /home/maposmatic/styles

git clone https://github.com/cquest/osmfr-cartocss.git
cd osmfr-cartocss
git checkout v2.8.0

ln -s /home/maposmatic/shapefiles data

sed '/"name":/d' < project.mml > osm.mml
carto -q -a $(mapnik-config -v) osm.mml > osm.xml

cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[french]
name: French
group: Countries
description: French OSM style
path: /home/maposmatic/styles/osmfr-cartocss/osm.xml

EOF

echo "  french," >> /home/maposmatic/ocitysmap/ocitysmap.styles

