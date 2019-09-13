#----------------------------------------------------
#
# Belgian OSM style
#
#----------------------------------------------------

cd /home/maposmatic/styles
git clone https://github.com/jbelien/openstreetmap-carto-be
cd openstreetmap-carto-be

ln -s /home/maposmatic/shapefiles data

sed -e '/\sname:/d' \
    -e 's/host:.*/host: "gis-db"/' \
    -e 's/user:.*/user: "maposmatic"\n    password: "secret"/' \
    -e 's/dbname:.*/dbname: "gis"/' \
< project.mml > osm.mml

carto -q -a $(mapnik-config -v) --quiet osm.mml > osm.xml
php /vagrant/files/postprocess-style.php osm.xml

cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[belgian]
name: Belgian
group: Countries
description: Belgian fork of OSM Carto style
path: /home/maposmatic/styles/openstreetmap-carto-be/osm.xml

EOF

echo "  belgian," >> /home/maposmatic/ocitysmap/ocitysmap.styles
 
