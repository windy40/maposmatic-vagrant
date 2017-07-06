#! /bin/bash

cd /home/maposmatic/styles

git clone https://gitlab.com/hholzgra/pistemap.git

cd pistemap
git checkout maposmatic

ln -s ../mapnik2-osm/world_boundaries .

cd pistemap_symbols
ln -s ../../MapQuest-Mapnik-Style/mapquest_symbols/small-city.svg .
ln -s ../../MapQuest-Mapnik-Style/mapquest_symbols/large-city.svg .
ln -s ../../MapQuest-Mapnik-Style/mapquest_symbols/national-capital.svg .
cd ..


mkdir srtm
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

    gdaldem hillshade -q $a ${base}_warped.tif ${base}_hillshade.tif
done

cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[pistemap]
name: PisteMap
description: PisteMap style by Michael von Glasow
path: /home/maposmatic/styles/pistemap/pistemap.xml

EOF

echo "  pistemap," >> /home/maposmatic/ocitysmap/ocitysmap.styles

