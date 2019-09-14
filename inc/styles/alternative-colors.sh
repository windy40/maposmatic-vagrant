#! /bin/bash

cd /home/maposmatic/styles

git clone --quiet https://github.com/imagico/osm-carto-alternative-colors

cd osm-carto-alternative-colors

for sql in line-widths-generated z
do
    echo "Importing $sql"
    sed -e 's/900913/3857/g' < $sql.sql | sudo -u maposmatic psql gis 
done

ln -s /home/maposmatic/shapefiles data

sed -e '/\sname:/d' -e 's/900913/3857/g' < project.mml > osm.mml
carto -q -a $(mapnik-config -v) osm.mml > osm.xml
php /vagrant/files/postprocess-style.php osm.xml

