#----------------------------------------------------
#
# Import OSM data into database
#
#----------------------------------------------------

cd /home/maposmatic

# get style file

if ! test -f opentopomap.style
then
  wget https://raw.githubusercontent.com/der-stefan/OpenTopoMap/master/mapnik/osm2pgsql/opentopomap.style
fi

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
     --style=opentopomap.style \
     /vagrant/data.osm.pbf

# update import timestamp
sudo --user=maposmatic psql \
     --dbname=gis \
     --command="UPDATE maposmatic_admin SET last_update = NOW()"

