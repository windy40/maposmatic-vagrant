#----------------------------------------------------
#
# Old German style
#
#----------------------------------------------------
   
# we share boundaries with the "classic" mapnik OSM style
# but need to add some extra shape files
cd /home/maposmatic/styles/mapnik2-osm/world_boundaries

wget http://data.openstreetmapdata.com/land-polygons-split-3857.zip
unzip land-polygons-split-3857.zip
mv land-polygons-split-3857/* .
wget http://data.openstreetmapdata.com/simplified-land-polygons-complete-3857.zip
unzip simplified-land-polygons-complete-3857.zip
mv simplified-land-polygons-complete-3857/* . 
   
# check out current stylesheet source
cd /home/maposmatic/styles
svn checkout http://svn.openstreetmap.org/applications/rendering/mapnik-german/
cd mapnik-german

# build transliterate function

cd utf8translit
make install
sudo -u maposmatic psql gis --command "CREATE FUNCTION transliterate(text) RETURNS text AS '$libdir/utf8translit', 'transliterate' LANGUAGE C STRICT;" 

cd ..

# create some extra database views
for sql in views/*.sql
do
    sudo -u maposmatic psql gis < $sql
done

# fix a SQL problem in the stylesheet:
sed -ie "s/ele,'FM9999D99'/ele::float,'FM9999D99'/g" osm-de.xml

# set up the actual stylesheet
/home/maposmatic/styles/mapnik2-osm/generate_xml.py osm-de.xml osm.xml \
          --host 'localhost' \
          --port 5432 \
          --dbname gis \
          --prefix view_osmde \
          --user maposmatic \
          --password 'secret' \
          --inc $(pwd)/inc-de \
          --world_boundaries /home/maposmatic/styles/mapnik2-osm/world_boundaries


