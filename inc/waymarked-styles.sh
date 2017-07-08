#! /bin/bash

cd /home/maposmatic/styles

git clone https://github.com/hholzgra/waymarked-trails-site.git
cd waymarked-trails-site
git checkout svg-symbols

git clone https://github.com/osmcode/pyosmium.git
cd pyosmium
python3 setup.py install
cd ..


git clone https://github.com/lonvia/osgende.git
cd osgende
python3 setup.py install
cd ..


DBNAME=planet
FILE=/vagrant/data.osm.pbf
FILEDATE=$(date -r $FILE "+%Y-%m-%d %H:%M:%S")

sudo -u maposmatic dropdb $DBNAME

echo "Importing main DB"
time sudo -u maposmatic python3 makedb.py -d $DBNAME -j 8 -f ../planet-latest.osm.pbf db import

echo "Indexing main DB"
time sudo -u maposmatic python3 makedb.py -d $DBNAME db prepare

echo "Importing countries table"
time sudo -u maposmatic psql $DBNAME < countries.dbdump

for style in hiking cycling mtb riding skating slopes
do
  echo "Creating $style DB"
  time sudo -u maposmatic python3 makedb.py -d $DBNAME $style create

  echo "Importing $style DB"
  time sudo -u maposmatic python3 makedb.py -d $DBNAME $style import
done


