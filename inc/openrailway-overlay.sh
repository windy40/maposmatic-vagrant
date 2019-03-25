#! /bin/bash

cd /home/maposmatic/styles

git clone https://github.com/Nakaner/OpenRailwayMap-webmap-styles

cd OpenRailwayMap-webmap-styles

carto -a $(mapnik-config -v) --quiet project.mml  > railmap.xml
php /vagrant/files/postprocess-style.php railmap.xml

cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[rail_overlay]
name: OpenRailwayMap_Overlay
group: Transport
description: OpenRailwayMap rail line overlay
path: /home/maposmatic/styles/OpenRailwayMap-webmap-styles/railmap.xml
EOF

echo "  rail_overlay," >> /home/maposmatic/ocitysmap/ocitysmap.overlays


