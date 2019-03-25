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
group: Special Interest
description: Schwarzkarte Overlay - showing building polygons only
path: /home/maposmatic/styles/Mapnik-schwarzkarte-overlay/schwarzkarte.xml
annotation: Schwarzplan overlay
url: http://www.osm-baustelle.de/dokuwiki/overlay:schwarzplan

EOF

echo "  schwarzkarte_overlay," >> /home/maposmatic/ocitysmap/ocitysmap.overlays
