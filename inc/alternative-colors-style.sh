#! /bin/bash

cd /home/maposmatic/styles

git clone https://github.com/imagico/osm-carto-alternative-colors

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

cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[alt_colors]
name: AlternativeColors
group: Artistic
description: Alternative Colors style by Christoph Hormann
path: /home/maposmatic/styles/osm-carto-alternative-colors/osm.xml
annotation: Alternative Colors style based on CartoOSM

EOF

echo "  alt_colors," >> /home/maposmatic/ocitysmap/ocitysmap.styles
 
