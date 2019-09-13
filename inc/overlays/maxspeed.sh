#----------------------------------------------------
#
# Maxspeed overlay
#
#----------------------------------------------------

cd /home/maposmatic/styles

git clone https://github.com/hholzgra/Mapnik-maxspeed-overlay.git

cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[maxspeed_overlay]
name: MaxspeedOverlay
group: Special Interest
description: Maxspeed Overlay
path: /home/maposmatic/styles/Mapnik-maxspeed-overlay/maxspeed.xml

EOF

echo "  maxspeed_overlay," >> /home/maposmatic/ocitysmap/ocitysmap.overlays


