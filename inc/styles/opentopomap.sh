#! /bin/bash

cd $STYLEDIR

git clone --quiet https://github.com/hholzgra/OpenTopoMap.git
cd OpenTopoMap
git remote add pushme git@github.com:hholzgra/OpenTopoMap.git
git remote add upstream https://github.com/der-stefan/OpenTopoMap
git checkout --quiet hartmut-dev
cd mapnik

ln -s $SHAPEFILE_DIR/ data
ln -s $SHAPEFILE_DIR/world_boundaries .
ln -s $INSTALLDIR/elevation-data/dem .

# all OpenTopoMap rules do render to zoom level 17 max.; not beyond
# we remove this lower limit so that highest zoom rules work for
# even highr zoom levels, too

for file in *.xml
do
    sed -i -e's/&minscale_zoom17;//g' $file
done

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



