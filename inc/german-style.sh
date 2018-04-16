#----------------------------------------------------
#
# German CartoOsm style sheet - the current openstreetmap.de style
#
#----------------------------------------------------

cd /home/maposmatic/styles

git clone https://github.com/giggls/openstreetmap-carto-de.git

cd openstreetmap-carto-de

sed -i -e's/dbname: "osm"/dbname: "gis"/' project.mml
make
ln -s /home/maposmatic/shapefiles data

cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[german_carto]
name: GermanCartoOSM
description: German CartoCSS OSM style
path: /home/maposmatic/styles/openstreetmap-carto-de/osm-de.xml

EOF

echo "  german_carto," >> /home/maposmatic/ocitysmap/ocitysmap.styles


