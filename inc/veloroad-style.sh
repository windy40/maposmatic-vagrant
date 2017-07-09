#! /bin/bash

cd /home/maposmatic/styles/

git clone https://github.com/hholzgra/veloroad.git
cd veloroad
git checkout hstore

./get-shapefiles.sh

sed '/"name":/d' < project.mml > osm.mml
carto osm.mml > veloroad.xml

cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[veloroad]
name: Veloroad
description: Veloroad by Ilya Zverev
path: /home/maposmatic/styles/veloroad/veloroad.xml

EOF

echo "  veloroad," >> /home/maposmatic/ocitysmap/ocitysmap.styles


