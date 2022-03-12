#! /bin/bash

cd /home/maposmatic/styles

git clone --quiet https://github.com/imagico/osm-carto-alternative-colors

cd osm-carto-alternative-colors

# SQL file execution order is important
# TODO: how to deal with indexes.sql ?
for sql in ac-light line-widths-generated scale_factor roads z 
do
    echo "Importing $sql"
    sudo -u maposmatic psql gis sql/$sql.sql
done

ln -s /home/maposmatic/shapefiles data

sed -e '/\sname:/d' -e 's/900913/3857/g' < project.mml > osm.mml
carto -q -a $(mapnik-config -v) osm.mml > osm.xml
php /vagrant/files/tools/postprocess-style.php osm.xml

