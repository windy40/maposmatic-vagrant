#----------------------------------------------------
#
# Import OSM data into database
#
#----------------------------------------------------

OSM_EXTRACT="${OSM_EXTRACT:-/vagrant/data.osm.pbf}"

cd /home/maposmatic

# get style file

if ! test -f hstore-only.style
then
  wget https://raw.githubusercontent.com/giggls/openstreetmap-carto-de/master/hstore-only.style
fi
if ! test -f openstreetmap-carto.lua
then
  wget https://raw.githubusercontent.com/giggls/openstreetmap-carto-de/master/openstreetmap-carto.lua
fi

# import data
sudo --user=maposmatic osm2pgsql \
     --create \
     --slim \
     --database=gis \
     --merc \
     --hstore-all \
     --cache=1000 \
     --number-processes=2 \
     --style=hstore-only.style \
     --tag-transform-script=openstreetmap-carto.lua \
     --prefix=planet_osm_hstore \
     $OSM_EXTRACT

# install views to provide expected table layouts from hstore-only bas tables

for dir in db_indexes db_functions db_views
do
  for sql in /vagrant/files/$dir/*.sql
  do
    sudo -u maposmatic psql gis < $sql
  done
done

# update import timestamp
sudo --user=maposmatic psql \
     --dbname=gis \
     --command="UPDATE maposmatic_admin SET last_update = NOW()"

