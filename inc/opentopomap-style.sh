#! /bin/bash

cd /home/maposmatic/styles

git clone https://github.com/hholzgra/OpenTopoMap.git
cd OpenTopoMap
git checkout hartmut-dev
cd mapnik

ln -s ../../mapnik2-osm/world_boundaries .

mkdir -p data 
cd data
wget http://data.openstreetmapdata.com/water-polygons-generalized-3857.zip
unzip water-polygons-generalized-3857.zip
wget http://data.openstreetmapdata.com/water-polygons-split-3857.zip
unzip water-polygons-split-3857.zip
cd ..

cd tools

cc -o saddledirection saddledirection.c -lm -lgdal
install saddledirection /usr/local/bin

wget http://katze.tfiu.de/projects/phyghtmap/phyghtmap_1.71.orig.tar.gz
tar -xvf phyghtmap_1.71.orig.tar.gz
cd phyghtmap-1.71
python setup.py install
cd ..

sudo -u maposmatic ./update_lowzoom.sh

cd ..

mkdir dem
cd dem

cp ../relief.txt .

for a in $(find /home/maposmatic/styles/pistemap/srtm/ -name "*.hgt")
do
  echo $(basename $a)
  gdal_fillnodata.py $a $(basename $a).tif
done

gdal_merge.py -n 32767 -co BIGTIFF=YES -co TILED=YES -co COMPRESS=LZW -co PREDICTOR=2 -o raw.tif *.hgt.tif

interpolation=cubicspline
for r in 90 500 1000 5000
do
  gdalwarp -co BIGTIFF=YES -co TILED=YES -co COMPRESS=LZW -co PREDICTOR=2 -t_srs "+proj=merc +ellps=sphere +R=6378137 +a=6378137 +units=m" -r $interpolation -tr $r $r raw.tif warp-$r.tif
  interpolation=bilinear
done

gdaldem color-relief -co COMPRESS=LZW -co PREDICTOR=2 -alpha warp-5000.tif relief.txt relief-5000.tif
gdaldem color-relief -co COMPRESS=LZW -co PREDICTOR=2 -alpha warp-500.tif relief.txt relief-500.tif

gdaldem hillshade -z 7 -compute_edges -co COMPRESS=JPEG warp-5000.tif hillshade-5000.tif
gdaldem hillshade -z 7 -compute_edges -co BIGTIFF=YES -co TILED=YES -co COMPRESS=JPEG warp-1000.tif hillshade-1000.tif
gdaldem hillshade -z 4 -compute_edges -co BIGTIFF=YES -co TILED=YES -co COMPRESS=JPEG warp-500.tif hillshade-500.tif
gdaldem hillshade -z 2 -co compress=lzw -co predictor=2 -co bigtiff=yes -compute_edges warp-90.tif hillshade-90.tif && gdal_translate -co compress=JPEG -co bigtiff=yes -co tiled=yes hillshade-90.tif hillshade-90-jpeg.tif

sudo -u maposmatic psql gis < /vagrant/files/contours_schema.sql
sudo -u maposmatic psql contours < /vagrant/files/contours_53-8.sql

cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[opentopomap]
name: OpenTopoMap
description: OpenTopoMap
path: /home/maposmatic/styles/OpenTopoMap/mapnik/opentopomap.xml

EOF

echo "  humanitarian," >> /home/maposmatic/ocitysmap/ocitysmap.styles


