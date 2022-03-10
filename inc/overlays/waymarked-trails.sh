#! /bin/bash

DBNAME=planet
FILE="${OSM_EXTRACT:-/vagrant/data.osm.pbf}"
FILEDATE=$(date -r $FILE "+%Y-%m-%d %H:%M:%S")
STYLES="hiking cycling mtb riding skating slopes"
REPLICATION_BASE_URL="$(osmium fileinfo -g 'header.option.osmosis_replication_base_url' "${FILE}")"
if test -z "$REPLICATION_BASE_URL"
then
	REPLICATION_BASE_OPTION=''
else
	REPLICATION_BASE_OPTION="-r $REPLICATION_BASE_URL"
fi

cd /home/maposmatic/styles/

pip3 install  git+https://github.com/waymarkedtrails/osgende@master \
	      git+https://github.com/waymarkedtrails/waymarkedtrails-shields@master

git clone  https://github.com/waymarkedtrails/waymarkedtrails-backend

cd waymarkedtrails-backend

pip3 install .

mkdir symbols
chown maposmatic symbols

sudo -u maposmatic dropdb --if-exists $DBNAME

echo "Importing main DB"
sudo -u maposmatic wmt-makedb -f $FILE db import

echo "Importing countries table"
(
  cd $CACHEDIR
  mkdir -p postgres
  cd postgres
  wget -qN http://www.nominatim.org/data/country_grid.sql.gz
)
zcat $CACHEDIR/postgres/country_grid.sql.gz | sudo -u maposmatic psql -d $DBNAME
sudo -u maposmatic psql -d $DBNAME -c "ALTER TABLE country_osm_grid ADD COLUMN geom geometry(Geometry,3857); UPDATE country_osm_grid SET geom=ST_Transform(geometry, 3857); ALTER TABLE country_osm_grid DROP COLUMN geometry"

echo "Indexing main DB"
sudo -u maposmatic wmt-makedb db prepare

for style in $STYLES
do
  echo "Creating $style DB"
  time sudo -u maposmatic wmt-makedb $style create

  echo "Importing $style DB"
  time sudo -u maposmatic wmt-makedb $style import

  echo "Indexing $style DB"
  time sudo -u maposmatic wmt-makedb $style dataview

  echo "Creating $style stylefile"
  wmt-makedb $style mapstyle > $style.xml
done

sudo -u maposmatic psql planet -c "create table waymarked_admin(last_update timestamp)"
sudo -u maposmatic psql planet -c "insert into waymarked_admin select MIN(date) from status"

if ! test -z "$REPLICATION_BASE_URL"
then
    echo ${REPLICATION_BASE_URL} > "${OSMOSIS_DIFFIMPORT}/baseurl.txt"

    cp $FILEDIR/systemd/waymarked-update.* /etc/systemd/system
    chmod 644 /etc/systemd/system/waymarked-update.*
    systemctl daemon-reload
    systemctl enable waymarked-update.timer
    systemctl start waymarked-update.timer
fi

