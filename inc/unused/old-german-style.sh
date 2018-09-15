#----------------------------------------------------
#
# Old German style
#
#----------------------------------------------------
   
# we share boundaries with the "classic" mapnik OSM style
ln -s /home/maposmatic/shapefiles/world_boundaries/ .
   
# check out current stylesheet source
cd /home/maposmatic/styles
svn checkout http://svn.openstreetmap.org/applications/rendering/mapnik-german/
cd mapnik-german

# build transliterate function

cd utf8translit
make install
sudo -u maposmatic psql gis --command "CREATE FUNCTION transliterate(text) RETURNS text AS 'utf8translit', 'transliterate' LANGUAGE C STRICT;" 

cd ..

# create some extra database views
# for sql in views/*.sql
# do
#     sudo -u maposmatic psql gis < $sql
# done

# fix a SQL problem in the stylesheet:
sed -ie "s/ele,'FM9999D99'/ele::float,'FM9999D99'/g" osm-de.xml

# set up the actual stylesheet
/home/maposmatic/styles/mapnik2-osm/generate_xml.py osm-de.xml osm.xml \
          --host 'localhost' \
          --port 5432 \
          --dbname gis \
          --prefix planet_osm \
          --user maposmatic \
          --password 'secret' \
          --inc $(pwd)/inc-de \
          --world_boundaries /home/maposmatic/styles/mapnik2-osm/world_boundaries

cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[german_osm]
name: GermanOSM
description: Old openstreetmap.de style
path: /home/maposmatic/styles/mapnik-german/osm-de.xml

EOF

echo "  german_osm," >> /home/maposmatic/ocitysmap/ocitysmap.styles


