#! /bin/bash

cd /home/maposmatic/styles

git clone --quiet https://github.com/hholzgra/OpenTopoMap.git
cd OpenTopoMap
git checkout --quiet hartmut-dev
cd mapnik

ln -s /home/maposmatic/shapefiles data
ln -s /home/maposmatic/shapefiles/world_boundaries .
ln -s /home/maposmatic/elevation-data/dem .

# build the bundled utility programs

cd tools

cc -w -o saddledirection saddledirection.c -lm -lgdal
install saddledirection /usr/local/bin
cc -w -o isolation isolation.c -lgdal -lm -O2
install isolation /usr/local/bin

cd ..


echo "station direction"
sudo -u maposmatic psql gis < tools/stationdirection.sql >/dev/null

echo "view point direction"
sudo -u maposmatic psql gis < tools/viewpointdirection.sql >/dev/null

echo "pitchicon"
sudo -u maposmatic psql gis < tools/pitchicon.sql >/dev/null

echo "update area labels"
sudo -u maposmatic psql gis < tools/arealabel.sql >/dev/null


cd ..

echo "update lowzoom"
sudo -u maposmatic mapnik/tools/update_lowzoom.sh >/dev/null

echo "update saddles"
sudo -u maposmatic mapnik/tools/update_saddles.sh >/dev/null

echo "update isolations"
sudo -u maposmatic mapnik/tools/update_isolations.sh >/dev/null



