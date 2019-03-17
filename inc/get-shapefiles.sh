#! /bin/bash

DOWNLOAD_DIR=$CACHEDIR/shapefiles
SHAPEFILE_DIR=/home/maposmatic/shapefiles

mkdir -p $DOWNLOAD_DIR
mkdir -p $SHAPEFILE_DIR

OSMDATA=https://osmdata.openstreetmap.de/download
OSMDATA_OLD=http://data.openstreetmapdata.com
OSM_HISTORICAL=http://planet.openstreetmap.org/historical-shapefiles
OSM_TILE=http://tile.openstreetmap.org
NATURAL_EARTH=http://www.naturalearthdata.com/http//www.naturalearthdata.com/download
OSM_BAUSTELLE=http://www.osm-baustelle.de
VELOROAD=http://zverik.openstreetmap.ru

for url in \
    $OSMDATA/land-polygons-split-3857.zip \
    $OSMDATA/simplified-land-polygons-complete-3857.zip \
    $OSMDATA/water-polygons-split-3857.zip \
    $OSMDATA/coastlines-split-3857.zip \
    $OSMDATA/antarctica-icesheet-outlines-3857.zip \
    $OSMDATA/antarctica-icesheet-polygons-3857.zip \
    \
    $OSMDATA_OLD/lakes-polygons-reduced-3857.zip \
    $OSMDATA_OLD/ocean-polygons-reduced-3857.zip \
    $OSMDATA_OLD/river-polygons-reduced-3857.zip \
    $OSMDATA_OLD/simplified-water-polygons-complete-3857.zip \
    \
    $OSM_HISTORICAL/world_boundaries-spherical.tgz \
    \
    $OSM_TILE/processed_p.tar.bz2 \
    $OSM_TILE/shoreline_300.tar.bz2 \
    \
    $NATURAL_EARTH/10m/cultural/ne_10m_admin_0_boundary_lines_land.zip \
    $NATURAL_EARTH/10m/cultural/ne_10m_admin_0_boundary_lines_map_units.zip \
    $NATURAL_EARTH/10m/cultural/ne_10m_admin_0_countries_lakes.zip \
    $NATURAL_EARTH/10m/cultural/ne_10m_admin_1_states_provinces_lines.zip \
    $NATURAL_EARTH/10m/cultural/ne_10m_airports.zip \
    $NATURAL_EARTH/10m/cultural/ne_10m_populated_places.zip \
    $NATURAL_EARTH/10m/cultural/ne_10m_populated_places_simple.zip \
    $NATURAL_EARTH/10m/cultural/ne_10m_roads.zip \
    $NATURAL_EARTH/10m/physical/ne_10m_coastline.zip \
    $NATURAL_EARTH/10m/physical/ne_10m_geography_marine_polys.zip \
    $NATURAL_EARTH/10m/physical/ne_10m_lakes.zip \
    $NATURAL_EARTH/10m/physical/ne_10m_land.zip \
    $NATURAL_EARTH/10m/physical/ne_10m_ocean.zip \
    \
    $NATURAL_EARTH/50m/cultural/ne_50m_admin_0_boundary_lines_land.zip \
    $NATURAL_EARTH/50m/cultural/ne_50m_admin_0_countries_lakes.zip \
    $NATURAL_EARTH/50m/cultural/ne_50m_admin_1_states_provinces_lines.zip \
    $NATURAL_EARTH/50m/physical/ne_50m_geography_marine_polys.zip \
    $NATURAL_EARTH/50m/physical/ne_50m_lakes.zip \
    $NATURAL_EARTH/50m/physical/ne_50m_land.zip \
    \
    $NATURAL_EARTH/110m/cultural/ne_110m_admin_0_boundary_lines_land.zip \
    $NATURAL_EARTH/110m/physical/ne_110m_geography_marine_polys.zip \
    \
    $OSM_BAUSTELLE/mercator_tiffs.tar.bz2 \
    \
    $VELOROAD/gmted25.tar.xz \

do
    cd $DOWNLOAD_DIR
    archive=$(basename $url)
    ext=${archive#*.}
    archbase=$(basename $archive .$ext)
    echo -n "downloading $archive"
    rm -f $archive.1
    wget -N --backups=1 --no-check-certificate $url || exit
    if [ \( -f $DOWNLOAD_DIR/$archive.1 \) -o \( ! -d $SHAPEFILE_DIR/$archbase \) ]
    then
	echo -n " ... unpacking"
        rm -f $archive.1    
        cd $SHAPEFILE_DIR
        rm -rf tmp
	mkdir tmp
        cd tmp
        if [ $ext = 'zip' ]
        then
            unzip -q $DOWNLOAD_DIR/$archive
        else
	    tar -xf $DOWNLOAD_DIR/$archive
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

cd $SHAPEFILE_DIR/ne_10m_populated_places
ogr2ogr --config SHAPE_ENCODING UTF8 ne_10m_populated_places_fixed.shp ne_10m_populated_places.shp

cd $SHAPEFILE_DIR
for a in mercator_tiffs/*.tif
do 
    rm -f $(basename $a)
    ln -s $a .
done

ln -s gmted25 gmted

rm -rf world_boundaries
mkdir world_boundaries

for d in world_boundaries-spherical shoreline_300 ne_10m_populated_places ne_110m_admin_0_boundary_lines_land mercator_tiffs land-polygons-split-3857 simplified-land-polygons-complete-3857 processed_p
do
	for f in $d/*
	do
		b=$(basename $f)
		r=$(realpath $f)
		if ! test -f world/boundaries/$b
		then
		    ln -s $r world_boundaries/$b
	        fi
	done
done

cd world_boundaries
for f in ne_110m_admin_0_boundary_lines_land.*
do
	f2=$(echo $f | sed -e's/ne_110/110/g')
	rm -f $f2
	ln -s $f $f2
done

cd ..


