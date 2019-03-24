#! /bin/bash

cd /home/maposmatic/styles

git clone https://github.com/hholzgra/OpenTopoMap.git
cd OpenTopoMap
git checkout hartmut-dev
cd mapnik

ln -s /home/maposmatic/shapefiles data
ln -s /home/maposmatic/shapefiles/world_boundaries .

cd tools

cc -o saddledirection saddledirection.c -lm -lgdal
install saddledirection /usr/local/bin
cc -Wall -o isolation isolation.c -lgdal -lm -O2
install isolation /usr/local/bin

wget http://katze.tfiu.de/projects/phyghtmap/phyghtmap_1.71.orig.tar.gz
tar -xvf phyghtmap_1.71.orig.tar.gz
cd phyghtmap-1.71
python setup.py install
cd ..


cd ..

mkdir dem
cd dem

cp ../relief.txt .

for a in $(find /home/maposmatic/styles/pistemap/srtm/ -name "*.hgt")
do
  echo $(basename $a)
  gdal_fillnodata.py -q $a $(basename $a).tif
done

gdal_merge.py -n 32767 -co BIGTIFF=YES -co TILED=YES -co COMPRESS=LZW -co PREDICTOR=2 -o raw.tif *.hgt.tif
ln -s raw.tif dem-srtm.tiff

ln -s raw.tif dem_srtm.tiff

interpolation=cubicspline
for r in 90 500 1000 5000
do
  gdalwarp -co BIGTIFF=YES -co TILED=YES -co COMPRESS=LZW -co PREDICTOR=2 -t_srs "+proj=merc +ellps=sphere +R=6378137 +a=6378137 +units=m" -r $interpolation -tr $r $r raw.tif warp-$r.tif -q
  interpolation=bilinear
done

gdaldem color-relief -co COMPRESS=LZW -co PREDICTOR=2 -alpha warp-5000.tif relief.txt relief-5000.tif -q
gdaldem color-relief -co COMPRESS=LZW -co PREDICTOR=2 -alpha warp-500.tif relief.txt relief-500.tif -q

gdaldem hillshade -z 7 -compute_edges -co COMPRESS=JPEG warp-5000.tif hillshade-5000.tif -q
gdaldem hillshade -z 7 -compute_edges -co BIGTIFF=YES -co TILED=YES -co COMPRESS=JPEG warp-1000.tif hillshade-1000.tif -q
gdaldem hillshade -z 4 -compute_edges -co BIGTIFF=YES -co TILED=YES -co COMPRESS=JPEG warp-500.tif hillshade-500.tif -q
gdaldem hillshade -z 2 -co compress=lzw -co predictor=2 -co bigtiff=yes -compute_edges warp-90.tif hillshade-90.tif && gdal_translate -co compress=JPEG -co bigtiff=yes -co tiled=yes hillshade-90.tif hillshade-90-jpeg.tif -q

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


echo "contours schema"
sudo -u maposmatic psql gis < /vagrant/files/contours_schema.sql >/dev/null

echo "countours data"
sudo -u maposmatic psql contours < /vagrant/files/contours_53-8.sql >/dev/null


cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[opentopomap]
name: OpenTopoMap
group: Special Interest
description: OpenTopoMap
path: /home/maposmatic/styles/OpenTopoMap/mapnik/opentopomap.xml

EOF

echo "  opentopomap," >> /home/maposmatic/ocitysmap/ocitysmap.styles


