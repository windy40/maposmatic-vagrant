#----------------------------------------------------
#
# MapOSMatic Printable stylesheet
#
#----------------------------------------------------

cd /home/maposmatic/styles

# configure the actual stylesheet
cd ../ocitysmap/stylesheet/maposmatic-printable

/vagrant/files/generate_xml.py \
       --dbname gis \
       --host 'localhost' \
       --user maposmatic \
       --port 5432 \
       --password 'secret' \
       --world_boundaries /home/maposmatic/shapefiles/world_boundaries \
       --symbols /home/maposmatic/styles/mapnik2-osm/symbols

