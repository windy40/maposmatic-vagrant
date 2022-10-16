local places = osm2pgsql.define_table({
    name = 'places',
    columns = {
        { column = 'name',              type = 'text' },
--        { column = 'alternative_names', type = 'text' },
        { column = 'osm_type',          type = 'text' },
	{ column = 'osm_id',            type = 'bigint' },
--	{ column = 'class',             type = 'text' },
	{ column = 'type',              type = 'text' },
--	{ column = 'lon',               type = 'real' },
--	{ column = 'lat',               type = 'real' },
  	{ column = 'place_rank',        type = 'real' },
--	{ column = 'importance',        type = 'real' },
--	{ column = 'country_code',      type = 'text' },
--	{ column = 'display_name',      type = 'text' },
	{ column = 'west',              type = 'real' },
	{ column = 'south',             type = 'real' },
	{ column = 'east',              type = 'real' },
	{ column = 'north',             type = 'real' }
}})

local function place_rank(object)
    if object.tags.admin_level then
       local level = tonumber(object.tags.admin_level) * 2
       if level > 0 then return level end
    end
    if object.tags.place then
        p = object.tags.place
	if p == 'continent'      then return  2 end
	if p == 'sea'            then return  2 end
	if p == 'ocean'          then return  2 end

	if p == 'country'        then return  4 end

	if p == 'country_region' then return  6 end

	if p == 'state'          then return  8 end

	if p == 'state_district' then return 10 end
	
	if p == 'county'         then return 12 end
	
	if p == 'city'           then return 16 end
	if p == 'water'          then return 16 end
	if p == 'desert'         then return 16 end
	
	if p == 'island'         then return 17 end
	if p == 'bay'            then return 17 end
	if p == 'river'          then return 17 end
	
	if p == 'region'         then return 18 end
	if p == 'peak'           then return 18 end
	if p == 'volcano'        then return 18 end
	if p == 'town'           then return 18 end
	
	if p == 'village'	 then return 19 end
	if p == 'hamlet' 	 then return 19 end
	if p == 'municipality' 	 then return 19 end
	if p == 'district' 	 then return 19 end
	if p == 'city_district'  then return 19 end
	if p == 'unincorporated_area' then return 19 end
	if p == 'borough'        then return 19 end
	if p == 'aerodrome' 	 then return 19 end
	
	if p == 'suburb'	 then return 20 end
	if p == 'subdivision' 	 then return 20 end
	if p == 'isolated_dwelling' then return 20 end
	if p == 'farm' 		 then return 20 end
	if p == 'locality' 	 then return 20 end
	if p == 'islet' 	 then return 20 end
	if p == 'mountain_pass'  then return 20 end
	if p == 'hill' 		 then return 20 end
	
	if p == 'neighbourhood' then return 22 end
	if p == 'residential'   then return 22 end
	if p == 'reservoir'     then return 22 end
	if p == 'stream'        then return 22 end
	
	if p == 'motorway' 	then return 26 end
	if p == 'trunk' 	then return 26 end
	if p == 'primary'	then return 26 end
	if p == 'secondary' 	then return 26 end
	if p == 'tertiary' 	then return 26 end
	if p == 'unclassified' 	then return 26 end
	if p == 'residential' 	then return 26 end
	if p == 'road' 		then return 26 end
	if p == 'living_street' then return 26 end
	if p == 'raceway' 	then return 26 end
	if p == 'construction' 	then return 26 end
	if p == 'track' 	then return 26 end
	if p == 'crossing' 	then return 26 end
	if p == 'riverbank' 	then return 26 end
	if p == 'canal' 	then return 26 end
	if p == 'station' 	then return 26 end
	
	if p == 'motorway_link' then return 27 end
	if p == 'trunk_link' 	then return 27 end
	if p == 'primary_link' 	then return 27 end
	if p == 'secondary_link' then return 27 end
	if p == 'tertiary_link' then return 27 end
	if p == 'service' 	then return 27 end
	if p == 'path' 		then return 27 end
	if p == 'cycleway' 	then return 27 end
	if p == 'steps' 	then return 27 end
	if p == 'bridleway' 	then return 27 end
	if p == 'footway' 	then return 27 end
	if p == 'corridor' 	then return 27 end
	if p == 'pedestrian' 	then return 27 end
	
	if p == 'houses' 	then return 28 end
    end
    return 30
end

function osm2pgsql.process_node(object)
    if not object.tags.name or object.tags.name == '' then -- TODO: trim
        return
    end
    
    if object.tags.place then
      places:insert({
        osm_type   = "node",
	osm_id     = object.id,
        name       = object.tags.name,
        type       = object.tags.place,
	place_rank = place_rank(object),
      })
    end
end

function osm2pgsql.process_way(object)
    if not object.tags.name or object.tags.name == '' then -- TODO: trim
        return
    end

    local lat1, lon1, lat2, lon2

    lat1,lon1,lat2,lon2 = object.get_bbox()
    
    if object.is_closed and object.tags.boundary == 'administrative' then
      places:insert({
        osm_type   = "way",
	osm_id     = object.id,
        name       = object.tags.name,
        type       = 'administrative',
	place_rank = place_rank(object),
	south      = lat1,
	north      = lat2,
	west       = lon1,
	east       = lon2,
      })
    end
end

function osm2pgsql.process_relation(object)
    if not object.tags.name or object.tags.name == '' then -- TODO: trim
        return
    end
    
    local lat1, lon1, lat2, lon2

    lat1,lon1,lat2,lon2 = object.get_bbox()
    
    if object.tags.boundary == 'administrative' then
      places:insert({
        osm_type   = "relation",
	osm_id     = object.id,
        name       = object.tags.name,
        type       = 'administrative',
	place_rank = place_rank(object),
	south      = lat1,
	north      = lat2,
	west       = lon1,
	east       = lon2,
	})
    end
end
