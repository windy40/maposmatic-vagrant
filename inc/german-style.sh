#----------------------------------------------------
#
# German CartoOsm style sheet - the current openstreetmap.de style
#
#----------------------------------------------------

cd /home/maposmatic/styles

git clone https://github.com/hholzgra/openstreetmap-carto-de.git

cd openstreetmap-carto-de
git checkout maposmatic

touch project.yaml
make
ln -s /home/maposmatic/shapefiles data
for sql_file in osm_tag2num.sql views_osmde/view-*.sql
do
    sudo -u maposmatic psql -d gis -f $sql_file
done 

cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[german_carto]
name: GermanCartoOSM
description: German CartoCSS OSM style
path: /home/maposmatic/styles/openstreetmap-carto-de/osm-de.xml

EOF

echo "  german_carto," >> /home/maposmatic/ocitysmap/ocitysmap.styles


