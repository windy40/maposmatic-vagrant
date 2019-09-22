#! /bin/bash

cd /home/maposmatic

psql gis -qt -c "
SELECT ST_Extent(bextent) 
FROM ( 
    SELECT ST_Extent(st_transform(way, 4326)) AS bextent FROM planet_osm_point 
  UNION ALL 
    SELECT ST_Extent(st_transform(way, 4326)) AS bextent FROM planet_osm_line 
  UNION ALL 
    SELECT ST_Extent(st_transform(way, 4326)) AS bextent FROM planet_osm_polygon
  ) a 
" > /home/maposmatic/bbox.wkt

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
