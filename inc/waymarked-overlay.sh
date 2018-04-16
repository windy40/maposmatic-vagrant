#! /bin/bash

DBNAME=planet
FILE=/vagrant/data.osm.pbf
FILEDATE=$(date -r $FILE "+%Y-%m-%d %H:%M:%S")
STYLES="hiking cycling mtb riding skating slopes"
COUNTRIES=/vagrant/files/countries.dbdump.bz2
 
cd /home/maposmatic/styles

git clone https://github.com/lonvia/waymarked-trails-site.git
cd waymarked-trails-site

sed -ie 's/www-data/maposmatic/g' config/defaults.py

chown -R maposmatic .

sudo -u maposmatic dropdb $DBNAME

echo "Importing main DB"
time sudo -u maposmatic python3 makedb.py -d $DBNAME -j 8 -f $FILE db import

echo "Indexing main DB"
time sudo -u maposmatic python3 makedb.py -d $DBNAME db prepare

echo "Importing countries table"
time (bzcat $COUNTRIES | sudo -u maposmatic psql $DBNAME)

for style in $STYLES
do
  echo "Creating $style DB"
  time sudo -u maposmatic python3 makedb.py -d $DBNAME $style create

  echo "Importing $style DB"
  time sudo -u maposmatic python3 makedb.py -d $DBNAME $style import

  cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[waymarked_$style]
name: WayMarked${style^}_Overlay
description: Way Marked Trails - ${style^}
path: /home/maposmatic/styles/waymarked-trails-site/maps/styles/${style}map.xml

EOF

  echo "  waymarked_$style,"  >> /home/maposmatic/ocitysmap/ocitysmap.overlays
done




