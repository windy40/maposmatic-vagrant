#----------------------------------------------------
#
# CartoOsm style sheet - the current OSM default style
#
#----------------------------------------------------

cd /home/maposmatic/styles
git clone --quiet https://github.com/gravitystorm/openstreetmap-carto.git
cd openstreetmap-carto
git checkout v4.22.0

ln -s /home/maposmatic/shapefiles data

sed '/\sname:/d' < project.mml > osm.mml
carto -a $(mapnik-config -v) --quiet osm.mml > osm.xml
php /vagrant/files/postprocess-style.php osm.xml

# create color-reduced variant of generated style

php /vagrant/files/bw.php

 
