#! /bin/bash

cd /home/maposmatic/styles

git clone https://github.com/hholzgra/mapbox-studio-space-station.tm2.git
cd mapbox-studio-space-station.tm2
git checkout dev-osm2pgsql

cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[spacestation]
name: Spacestation
group: Sports
description: Space station style - originally by Eleanor Lutz of Mabpox 
path: /home/maposmatic/styles/mapbox-studio-space-station.tm2/osm.xml

EOF

echo "  spacestation," >> /home/maposmatic/ocitysmap/ocitysmap.styles

