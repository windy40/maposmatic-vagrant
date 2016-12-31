#----------------------------------------------------
#
# Set up PostgreSQL and PostGIS 
#
#----------------------------------------------------

# add "gis" database user
sudo --user=postgres createuser --superuser --no-createdb --no-createrole maposmatic

# creade database for osm2pgsql import 
sudo --user=postgres createdb --encoding=UTF8 --owner=maposmatic gis

# set up PostGIS for osm2pgsql database
sudo --user=maposmatic psql --dbname=gis --command="CREATE EXTENSION postgis"
sudo --user=maposmatic psql --dbname=gis --command="ALTER TABLE geometry_columns OWNER TO maposmatic"
sudo --user=maposmatic psql --dbname=gis --command="ALTER TABLE spatial_ref_sys OWNER TO maposmatic"

# set up maposmatic admin table
sudo --user=maposmatic psql --dbname=gis --command="CREATE TABLE maposmatic_admin (last_update timestamp)"
sudo --user=maposmatic psql --dbname=gis --command="INSERT INTO maposmatic_admin VALUES ('1970-01-01 00:00:00')"

# enable hstore extension
sudo --user=maposmatic psql --dbname=gis --command="CREATE EXTENSION hstore"

# set password for gis database user
sudo --user=maposmatic psql --dbname=postgres --command="ALTER USER maposmatic WITH PASSWORD 'secret';"

#----------------------------------------------------
#
# build osml10n extension for PostgreSQL
#
#----------------------------------------------------

cd /home/maposmatic
git clone https://github.com/giggls/mapnik-german-l10n.git
cd mapnik-german-l10n
make install
sudo --user=maposmatic psql --dbname=gis --command="CREATE EXTENSION osml10n"

#-------------------------------------------------------
#
# some more contrib extensions required by german style
#
#--------------------------------------------------------

sudo --user=maposmatic psql --dbname=gis --command="CREATE EXTENSION fuzzystrmatch"
sudo --user=maposmatic psql --dbname=gis --command="CREATE EXTENSION unaccent"

