#----------------------------------------------------
# OpenArdenneMap - Belgian topographic map style
#----------------------------------------------------

cd /home/maposmatic/styles
git clone --quiet https://github.com/nobohan/OpenArdenneMap
cd OpenArdenneMap

cd osm2pgsql

sed -i -e 's/"osmpg_db"/"gis"/g' -e 's/"..\/..\/..\/Elevation\/contour_anlier.shp"/"..\/contour\/contour.shp"/g' project.mml

carto -a $(mapnik-config -v) --quiet project.mml > OpenArdenneMap.xml

php /vagrant/files/postprocess-style.php OpenArdenneMap.xml

