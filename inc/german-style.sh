#----------------------------------------------------
#
# German CartoOsm style sheet - the current openstreetmap.de style
#
#----------------------------------------------------

cd /home/maposmatic/styles

git clone https://github.com/giggls/openstreetmap-carto-de.git

cd openstreetmap-carto-de

sed -i -e's/dbname: "osm"/dbname: "gis"/' project.mml
sed -i -e's/carto /carto -q /g' Makefile
make

for a in *.xml
do
    php /vagrant/files/postprocess-style.php $a
done

ln -s /home/maposmatic/shapefiles data

cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[german_carto]
name: GermanCartoOSM
description: German CartoCSS OSM style
path: /home/maposmatic/styles/openstreetmap-carto-de/osm-de.xml
annotation: German OSM style
url: http://www.osm-baustelle.de/dokuwiki/doku.php?id=style:german

EOF

echo "  german_carto," >> /home/maposmatic/ocitysmap/ocitysmap.styles


