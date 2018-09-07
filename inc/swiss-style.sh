#----------------------------------------------------
#
# Swiss OSM style
#
#----------------------------------------------------

cd /home/maposmatic/styles
git clone https://github.com/xyztobixyz/OSM-Swiss-Style
cd OSM-Swiss-Style

ln -s /home/maposmatic/shapefiles data

sed '/\sname:/d' < project.mml > osm.mml
carto -a $(mapnik-config -v) --quiet osm.mml > osm.xml
php /vagrant/files/postprocess-style.php osm.xml

cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[swiss]
name: Swiss
description: Swiss OSM style
path: /home/maposmatic/styles/OSM-Swiss-Style/osm.xml

EOF

echo "  swiss," >> /home/maposmatic/ocitysmap/ocitysmap.styles
 
