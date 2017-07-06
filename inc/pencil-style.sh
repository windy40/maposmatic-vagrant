#! /bin/bash

cd /home/maposmatic/styles

git clone https://github.com/hholzgra/mapbox-studio-pencil.tm2.git
cd mapbox-studio-pencil.tm2
git checkout dev-osm2pgsql

cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[pencil]
name: Pencil
description: Pencil style - originally by AH Ashton of Mabpox 
path: /home/maposmatic/styles/mapbox-studio-pencil.tm2/osm.xml

EOF

echo "  pencil," >> /home/maposmatic/ocitysmap/ocitysmap.styles

