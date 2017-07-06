#----------------------------------------------------
#
# "Schwarzkarte" overlay, showing building polygons only
#
#----------------------------------------------------

cd /home/maposmatic/styles

git clone https://github.com/hholzgra/Mapnik-schwarzkarte-overlay.git

cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[schwarzkarte_overlay]
name: SchwarzkarteOverlay
description: Schwarzkarte Overlay - showing building polygons only
path: /home/maposmatic/styles/Mapnik-schwarzkarte-overlay/schwarzkarte.xml

EOF

echo "  schwarzkarte_overlay," >> /home/maposmatic/ocitysmap/ocitysmap.overlays
