#----------------------------------------------------
#
# Golf overlay style 
#
# Original on https://github.com/rweait/Mapnik-golf-overlay
#
#----------------------------------------------------

cd /home/maposmatic/styles

git clone https://github.com/hholzgra/Mapnik-golf-overlay.git
cd Mapnik-golf-overlay
git checkout maposmatic

cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[golf_overlay]
name: GolfOverlay
group: Special Interest
description: Golf course detail overlay
path: /home/maposmatic/styles/Mapnik-golf-overlay/golf.xml

EOF

echo "  golf_overlay," >> /home/maposmatic/ocitysmap/ocitysmap.overlays

