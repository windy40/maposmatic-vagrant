#-------------------------------------------------------
#
# contrib extensions required by osml10n extension
#
#--------------------------------------------------------

sudo --user=maposmatic psql --dbname=gis --command="CREATE EXTENSION fuzzystrmatch"
sudo --user=maposmatic psql --dbname=gis --command="CREATE EXTENSION unaccent"

#----------------------------------------------------------
#
# osml10n extension for PostgreSQL required by german style
#
#----------------------------------------------------------

cd /home/maposmatic
git clone https://github.com/giggls/mapnik-german-l10n.git
cd mapnik-german-l10n
make install
sudo --user=maposmatic psql --dbname=gis --command="CREATE EXTENSION osml10n"

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


