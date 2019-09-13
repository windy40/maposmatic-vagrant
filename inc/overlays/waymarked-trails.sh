#! /bin/bash

DBNAME=planet
FILE="${OSM_EXTRACT:-/vagrant/data.osm.pbf}"
FILEDATE=$(date -r $FILE "+%Y-%m-%d %H:%M:%S")
STYLES="hiking cycling mtb riding skating slopes"
 
cd /home/maposmatic/styles

git clone https://github.com/lonvia/waymarked-trails-site.git
cd waymarked-trails-site

sed -ie 's/www-data/maposmatic/g' config/defaults.py

chown -R maposmatic .

sudo -u maposmatic dropdb --if-exists $DBNAME

echo "Importing main DB"
time sudo -u maposmatic python3 makedb.py -d $DBNAME -j 8 -f $FILE db import

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

  cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[waymarked_$style]
name: WayMarked${style^}_Overlay
group: WayMaredTrails Routes
description: Way Marked Trails - ${style^}
path: /home/maposmatic/styles/waymarked-trails-site/maps/styles/${style}map.xml
url=http://www.osm-baustelle.de/dokuwiki/doku.php?id=overlay:waymarked

EOF

  echo "  waymarked_$style,"  >> /home/maposmatic/ocitysmap/ocitysmap.overlays

  sudo -u maposmatic psql planet -c "create table waymarked_admin(last_update timestamp)"
  sudo -u maposmatic psql planet -c "insert into waymarked_admin values(current_timestamp)"
done




