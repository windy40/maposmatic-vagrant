#----------------------------------------------------
#
# Swiss OSM style
#
#----------------------------------------------------

cd /home/maposmatic/styles
git clone --quiet https://github.com/xyztobixyz/OSM-Swiss-Style
cd OSM-Swiss-Style

ln -s /home/maposmatic/shapefiles data

sed '/\sname:/d' < project.mml > osm.mml
carto -a $(mapnik-config -v) --quiet osm.mml > osm.xml
php /vagrant/files/tools/postprocess-style.php osm.xml

