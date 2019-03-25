#----------------------------------------------------
#
# Gaslight overlay
#
#----------------------------------------------------

cd /home/maposmatic/styles

git clone https://github.com/hholzgra/Mapnik-gaslight-overlay.git

cd Mapnik-fire-overlay
for f in sql-functions/*.sql
do
    sudo -u maposmatic psql gis < $f
done
cd ..

cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[gaslight_overlay]
name: Gaslight_Overlay
group: Special Interest
description: Overlay for gas lit streets
path: /home/maposmatic/styles/Mapnik-gaslight-overlay/gaslight.xml

EOF

echo "  gaslight_overlay," >> /home/maposmatic/ocitysmap/ocitysmap.overlays

