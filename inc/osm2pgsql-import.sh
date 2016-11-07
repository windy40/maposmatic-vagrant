#----------------------------------------------------
#
# Import OSM data into database
#
#----------------------------------------------------

# import data
sudo --user=maposmatic osm2pgsql \
     --create \
     --slim \
     --database=gis \
     --merc \
     --hstore-all \
     --hstore-match-only \
     --cache=1000 \
     --number-processes=2 \
     --style=/home/maposmatic/styles/openstreetmap-carto/openstreetmap-carto.style \
     /vagrant/data.osm.pbf

# update import timestamp
sudo --user=maposmatic psql \
     --dbname=gis \
     --command="UPDATE maposmatic_admin SET last_update = NOW()"

