#! /bin/bash

cd /home/maposmatic/styles

git clone https://github.com/Nakaner/OpenRailwayMap-webmap-styles

cd OpenRailwayMap-webmap-styles

carto -a $(mapnik-config -v) project.mml | sed -e 's/comp-op="screen"//g' >  railmap.xml 2>/dev/null

cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[rail_overlay]
name: OpenRailwayMap_Overlay
description: OpenRailwayMap rail line overlay
path: /home/maposmatic/styles/OpenRailwayMap-webmap-styles/railmap.xml
EOF

echo "  rail_overlay," >> /home/maposmatic/ocitysmap/ocitysmap.overlays


