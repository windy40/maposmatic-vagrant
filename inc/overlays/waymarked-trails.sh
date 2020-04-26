#! /bin/bash

DBNAME=planet
FILE="${OSM_EXTRACT:-/vagrant/data.osm.pbf}"
FILEDATE=$(date -r $FILE "+%Y-%m-%d %H:%M:%S")
STYLES="hiking cycling mtb riding skating slopes"
REPLICATION_BASE_URL="$(osmium fileinfo -g 'header.option.osmosis_replication_base_url' "${OSM_EXTRACT}")"
if test -z "$REPLICATION_BASE_URL"
then
	REPLICATION_BASE_OPTION=''
else
	REPLICATION_BASE_OPTION="-r $REPLICATION_BASE_URL"
fi
 
cd /home/maposmatic/styles

git clone --quiet https://github.com/lonvia/waymarked-trails-site.git
cd waymarked-trails-site

sed -ie 's/www-data/maposmatic/g' config/defaults.py

chown -R maposmatic .

sudo -u maposmatic dropdb --if-exists $DBNAME

echo "Importing main DB"
time sudo -u maposmatic python3 makedb.py -d $DBNAME -j 8 -f $FILE $REPLICATION_BASE_OPTION db import

echo "Indexing main DB"
time sudo -u maposmatic python3 makedb.py -d $DBNAME db prepare

echo "Importing countries table"
(
  cd $CACHEDIR
  mkdir -p postgres
  cd postgres
  wget -qN http://www.nominatim.org/data/country_grid.sql.gz
)
zcat $CACHEDIR/postgres/country_grid.sql.gz | sudo -u maposmatic psql -d $DBNAME
sudo -u maposmatic psql -d $DBNAME -c "ALTER TABLE country_osm_grid ADD COLUMN geom geometry(Geometry,3857); UPDATE country_osm_grid SET geom=ST_Transform(geometry, 3857); ALTER TABLE country_osm_grid DROP COLUMN geometry"

for style in $STYLES
do
  echo "Creating $style DB"
  time sudo -u maposmatic python3 makedb.py -d $DBNAME $style create

  echo "Importing $style DB"
  time sudo -u maposmatic python3 makedb.py -d $DBNAME $style import
done

sudo -u maposmatic psql planet -c "create table waymarked_admin(last_update timestamp)"
sudo -u maposmatic psql planet -c "insert into waymarked_admin select MIN(date) from status"

if ! test -z "$REPLICATION_BASE_URL"
then
    echo ${REPLICATION_BASE_URL} > "${OSMOSIS_DIFFIMPORT}/baseurl.txt"

    cp /vagrant/files/systemd/waymarked-update.* /etc/systemd/system
    chmod 644 /etc/systemd/system/waymarked-update.*
    systemctl daemon-reload
    systemctl enable waymarked-update.timer
    systemctl start waymarked-update.timer
fi
