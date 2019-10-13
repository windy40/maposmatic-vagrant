#! /bin/bash

mkdir -p /home/maposmatic/bounds
cd /home/maposmatic/bounds

# extract bounding box rectangle

psql gis -qt -c "
SELECT ST_Extent(bextent) 
FROM ( 
    SELECT ST_Extent(st_transform(way, 4326)) AS bextent FROM planet_osm_point 
  UNION ALL 
    SELECT ST_Extent(st_transform(way, 4326)) AS bextent FROM planet_osm_line 
  UNION ALL 
    SELECT ST_Extent(st_transform(way, 4326)) AS bextent FROM planet_osm_polygon
  ) a 
" > bbox.wkt

# convert bbox to bash, json and python array formats

bbox=$(sed -e 's/.*BOX//g' -e 's/,/ /' < bbox.wkt)

echo $bbox > bbox.bash

eval b=$bbox

echo "{
  '_northEast': {
    'lon': ${b[2]},
    'lat': ${b[3]}
  },
  '_southWest': {
    'lon': ${b[0]},
    'lat': ${b[1]}
  }
}" | tr "'" '"' > bbox.json

echo "MAX_BOUNDING_BOX=(${b[1]}, ${b[0]}, ${b[3]}, ${b[2]})" > bbox.py


# extract simplified data bounds polygon

psql gis -tc "SELECT st_asgeojson(st_transform(st_simplify(way, 100),4326))
               FROM planet_osm_polygon
           ORDER BY way_area desc
              LIMIT 1" > inner.json

psql gis -tc "SELECT st_asgeojson(st_difference(st_geomfromtext('Polygon((-180 90, 180 90, 180 -90, -180 -90, -180 90))', 4326),st_transform(st_simplify(way, 100),4326)))
               FROM planet_osm_polygon
           ORDER BY way_area desc
              LIMIT 1" > outer.json
