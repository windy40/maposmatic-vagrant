#----------------------------------------------------
#
# Fire/Emergency overlay
#
# Original on https://github.com/rweait/Mapnik-golf-overlay
#
#----------------------------------------------------

cd /home/maposmatic/styles

git clone https://github.com/hholzgra/Mapnik-fire-overlay.git

cd Mapnik-fire-overlay
for f in sql-functions
do
    sudo -u maposmatic psql gis < $f
done
cd ..

cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[fire_overlay]
name: FireOverlay
description: Fire Hydrant Overlay
path: /home/maposmatic/styles/Mapnik-fire-overlay/fire.xml

EOF

echo "  fire_overlay," >> /home/maposmatic/ocitysmap/ocitysmap.overlays

