#! /bin/bash

cd /home/maposmatic/styles

git clone https://github.com/cquest/osmfr-cartocss.git
cd osmfr-cartocss
git checkout v2.8.0

./get-shapefiles.sh

sed '/"name":/d' < project.mml > osm.mml
carto -a 3.0.12 osm.mml > osm.xml

cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[french]
name: French
description: French OSM style
path: /home/maposmatic/styles/osmfr-cartocss/osm.xml

EOF

echo "  french," >> /home/maposmatic/ocitysmap/ocitysmap.styles

