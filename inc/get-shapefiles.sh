#! /bin/bash


SD=/vagrant/files/shapefiles
mkdir -p $SD
cd $SD
for url in \
    http://data.openstreetmapdata.com/antarctica-icesheet-outlines-3857.zip \
    http://data.openstreetmapdata.com/antarctica-icesheet-polygons-3857.zip \
    http://data.openstreetmapdata.com/land-polygons-split-3857.zip \
    http://data.openstreetmapdata.com/simplified-land-polygons-complete-3857.zip \
    http://data.openstreetmapdata.com/water-polygons-generalized-3857.zip \
    http://data.openstreetmapdata.com/water-polygons-split-3857.zip \
    http://data.openstreetmapdata.com/antarctica-icesheet-outlines-3857.zip \
    http://data.openstreetmapdata.com/antarctica-icesheet-polygons-3857.zip \
    http://data.openstreetmapdata.com/land-polygons-split-3857.zip \
    http://planet.openstreetmap.org/historical-shapefiles/world_boundaries-spherical.tgz \
    http://tile.openstreetmap.org/processed_p.tar.bz2 \
    http://tile.openstreetmap.org/shoreline_300.tar.bz2 \
    http://data.openstreetmapdata.com/simplified-land-polygons-complete-3857.zip \
    http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_boundary_lines_land.zip \
    http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_boundary_lines_map_units.zip \
    http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_countries_lakes.zip \
    http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_1_states_provinces_lines.zip \
    http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_airports.zip \
    http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_populated_places.zip \
    http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_roads.zip \
    http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/physical/ne_10m_geography_marine_polys.zip \
    http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/physical/ne_10m_lakes.zip \
    http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/cultural/ne_110m_admin_0_boundary_lines_land.zip \
    http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/physical/ne_110m_geography_marine_polys.zip \
    http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_boundary_lines_land.zip \
    http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries_lakes.zip \
    http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_1_states_provinces_lines.zip \
    http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/physical/ne_50m_geography_marine_polys.zip \
    http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/physical/ne_50m_lakes.zip \
    http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/physical/ne_50m_land.zip \
    http://zverik.osm.rambler.ru/gmted25.tar.xz \
    http://www.osm-baustelle.de/mercator_tiffs.tar.bz2 \

do
    wget -N $url
done    

cd /home/maposmatic
mkdir -p shapefiles
cd shapefiles

for ext in zip tgz tar.xz tar.bz2
do
    for archive in $SD/*.$ext 
    do
        echo $archive
        base=$(basename $archive .$ext)
        mkdir tmp
        cd tmp
        if [ $ext = 'zip' ]
        then
            unzip -q $archive
        else
	    tar -xf $archive
        fi
        if [ $(ls | wc -l) -eq 1 ]
        then
            mv * ..
	    cd ..
	    rmdir tmp 
        else
            cd ..
	    mv tmp $base
        fi
    done
done

cd ne_10m_populated_places
ogr2ogr --config SHAPE_ENCODING UTF8 ne_10m_populated_places_fixed.shp ne_10m_populated_places.shp
cd ..

for file in $(find /home/maposmatic/shapefiles -name *.shp)
do
    pushd $(dirname $file)
    shapeindex --shape_files $(basename $file)
    popd
done

for a in mercator_tiffs/*.tif
do 
    ln -s $a .
done


