#! /bin/bash

cd /home/maposmatic/styles

mkdir contour-overlay
cd contour-overlay
cp /vagrant/files/contour.xml .

cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[contour_overlay]
name: ContourOverlay
group: Heights
description: Countour lines at 10m resolution
path: /home/maposmatic/styles/contour-overlay/contour.xml

EOF

echo "  contour_overlay," >> /home/maposmatic/ocitysmap/ocitysmap.overlays


