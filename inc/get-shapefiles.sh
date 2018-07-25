#! /bin/bash

SD=/vagrant/files/shapefiles
WD=/home/maposmatic/shapefiles

mkdir -p $SD
mkdir -p $WD

for url in \
    http://data.openstreetmapdata.com/antarctica-icesheet-outlines-3857.zip \
    http://data.openstreetmapdata.com/antarctica-icesheet-polygons-3857.zip \
    http://data.openstreetmapdata.com/coastlines-split-3857.zip \
    http://data.openstreetmapdata.com/lakes-polygons-reduced-3857.zip \
    http://data.openstreetmapdata.com/land-polygons-split-3857.zip \
    http://data.openstreetmapdata.com/ocean-polygons-reduced-3857.zip \
    http://data.openstreetmapdata.com/river-polygons-reduced-3857.zip \
    http://data.openstreetmapdata.com/simplified-land-polygons-complete-3857.zip \
    http://data.openstreetmapdata.com/simplified-water-polygons-complete-3857.zip \
    http://data.openstreetmapdata.com/water-polygons-generalized-3857.zip \
    http://data.openstreetmapdata.com/water-polygons-split-3857.zip \
    http://planet.openstreetmap.org/historical-shapefiles/world_boundaries-spherical.tgz \
    http://tile.openstreetmap.org/processed_p.tar.bz2 \
    http://tile.openstreetmap.org/shoreline_300.tar.bz2 \
    http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_boundary_lines_land.zip \
    http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_boundary_lines_map_units.zip \
    http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_countries_lakes.zip \
    http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_1_states_provinces_lines.zip \
    http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_airports.zip \
    http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_populated_places.zip \
    http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_populated_places_simple.zip \
    http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_roads.zip \
    http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/physical/ne_10m_coastline.zip \
    http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/physical/ne_10m_geography_marine_polys.zip \
    http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/physical/ne_10m_lakes.zip \
    http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/physical/ne_10m_land.zip \
    http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/physical/ne_10m_ocean.zip \
    http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/cultural/ne_110m_admin_0_boundary_lines_land.zip \
    http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/physical/ne_110m_geography_marine_polys.zip \
    http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_boundary_lines_land.zip \
    http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries_lakes.zip \
    http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_1_states_provinces_lines.zip \
    http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/physical/ne_50m_geography_marine_polys.zip \
    http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/physical/ne_50m_lakes.zip \
    http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/physical/ne_50m_land.zip \
    http://www.osm-baustelle.de/mercator_tiffs.tar.bz2 \
    http://zverik.openstreetmap.ru/gmted25.tar.xz \

do
    cd $SD
    archive=$(basename $url)
    ext=${archive#*.}
    archbase=$(basename $archive .$ext)
    echo -n "downloading $archive"
    rm -f $archive.1
    wget -N --backups=1 $url
    if [ \( -f $SD/$archive.1 \) -o \( ! -d $WD/$archbase \) ]
    then
	echo -n " ... unpacking"
        rm -f $archive.1    
        cd $WD
        rm -rf tmp
	mkdir tmp
        cd tmp
        if [ $ext = 'zip' ]
        then
            unzip -q $SD/$archive
        else
	    tar -xf $SD/$archive
        fi
        if [ $(ls | wc -l) -eq 1 ]
        then
	    base=$(ls)
	    rm -rf ../$archbase 
	    mv $base ../$archbase
	    cd ..
	    rm -rf tmp 
        else
            cd ..
	    rm -rf $archbase
	    mv tmp $archbase
        fi
	cd $archbase
	echo -n " ... indexing"
	for a in *.shp
	do
	    shapeindex --shape_files $a >/dev/null 2>/dev/null
	done
	echo
    else
	echo "... unchanged"
    fi
done

cd $WD/ne_10m_populated_places
ogr2ogr --config SHAPE_ENCODING UTF8 ne_10m_populated_places_fixed.shp ne_10m_populated_places.shp

cd $WD
for a in mercator_tiffs/*.tif
do 
    rm -f $(basename $a)
    ln -s $a .
done

ln -s world_boundaries-spherical world_boundaries
ln -s gmted25 gmted
