#! /bin/bash

cd /home/maposmatic

mkdir -p elevation-data
cd elevation-data


echo "strm hillshading for PisteMap"

mkdir -p srtm
cd srtm

# see http://www.viewfinderpanoramas.org/Coverage%20map%20viewfinderpanoramas_org3.htm for letters/numbers

for x in N # L M N
do
  for y in 32 # 31 32 33
  do
    wget http://viewfinderpanoramas.org/dem3/$x$y.zip
  done
done
  
for zip in *.zip
do
  unzip $zip
done

for file in $(ls **/*.hgt | sort)
do
    base=$(basename $file .hgt)

    gdal_translate -q -of GTiff -co "TILED=YES" -a_srs "+proj=latlong" $file ${base}_adapted.tif

    gdalwarp -q -multi -of GTiff -co "TILED=YES" -srcnodata 32767 -t_srs "+proj=merc +ellps=sphere +R=6378137 +a=6378137 +units=m" -rcs -order 3 -tr 30 30 -multi ${base}_adapted.tif ${base}_warped.tif

    gdaldem hillshade -q ${base}_warped.tif ${base}_hillshade.tif
done


cd ..

echo "DEM data for OpenTopoMap"
mkdir -p dem
cd dem

cp /vagrant/files/relief_color_text_file.txt .

for a in $(find /home/maposmatic/elevation-data/srtm -name "*.hgt")
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

gdaldem color-relief -co COMPRESS=LZW -co PREDICTOR=2 -alpha warp-5000.tif relief_color_text_file.txt relief-5000.tif -q
gdaldem color-relief -co COMPRESS=LZW -co PREDICTOR=2 -alpha warp-500.tif relief_color_text_file.txt relief-500.tif -q

gdaldem hillshade -z 7 -compute_edges -co COMPRESS=JPEG warp-5000.tif hillshade-5000.tif -q
gdaldem hillshade -z 7 -compute_edges -co BIGTIFF=YES -co TILED=YES -co COMPRESS=JPEG warp-1000.tif hillshade-1000.tif -q
gdaldem hillshade -z 4 -compute_edges -co BIGTIFF=YES -co TILED=YES -co COMPRESS=JPEG warp-500.tif hillshade-500.tif -q
gdaldem hillshade -z 2 -co compress=lzw -co predictor=2 -co bigtiff=yes -compute_edges warp-90.tif hillshade-90.tif && gdal_translate -co compress=JPEG -co bigtiff=yes -co tiled=yes hillshade-90.tif hillshade-90-jpeg.tif -q

echo "contours schema"
sudo -u maposmatic psql gis < /vagrant/files/contours_schema.sql >/dev/null

echo "countours data"
sudo -u maposmatic psql contours < /vagrant/files/contours_53-8.sql >/dev/null

cd ..

