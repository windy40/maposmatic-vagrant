CREATE OR REPLACE VIEW planet_osm_roads AS
SELECT osm_id
-- original columns
, layer    as layer
, tags     as tags
, way      as way
, way_area as way_area
, z_order  as z_order
-- calculated columns
, osml10n_get_placename_from_tags(tags,true,false,' - ','de',way)   as localized_name_second
, osml10n_get_placename_from_tags(tags,false,false,' - ','de',way)  as localized_name_first
, osml10n_get_name_without_brackets_from_tags(tags,'de',way)        as localized_name_without_brackets
, osml10n_get_streetname_from_tags(tags,true,false,' - ','de', way) as localized_streetname
, osml10n_get_name_without_brackets_from_tags(tags,'oc',way) as name_fr_oc
, COALESCE(tags->'name:hsb',tags->'name:dsb',tags->'name')          as name_hrb
-- hstore tag 'columns' (sorted)
, tags->'access' as "access"
, tags->'addr:housenumber' as "addr:housenumber"
, tags->'admin_level' as "admin_level"
, tags->'aerialway' as "aerialway"
, tags->'aeroway' as "aeroway"
, tags->'amenity' as "amenity"
, tags->'barrier' as "barrier"
, tags->'bicycle' as "bicycle"
, tags->'boundary' as "boundary"
, tags->'bridge' as "bridge"
, tags->'building' as "building"
, tags->'covered' as "covered"
, tags->'highway' as "highway"
, tags->'historic' as "historic"
, tags->'int_name' as "int_name"
, tags->'junction' as "junction"
, tags->'lock' as "lock"
, tags->'man_made' as "man_made"
, tags->'name' as "name"
, tags->'name:de' as "name:de"
, tags->'name:en' as "name:en"
, tags->'name:oc' as "name:oc"
, tags->'power' as "power"
, tags->'railway' as "railway"
, tags->'ref' as "ref"
, tags->'route' as "route"
, tags->'service' as "service"
, tags->'shop' as "shop"
, tags->'surface' as "surface"
, tags->'toll' as "toll"
, tags->'tunnel' as "tunnel"
, tags->'waterway' as "waterway"
, tags->'width' as "width"
-- after initial import add further columns below this line only
FROM planet_osm_hstore_roads;

GRANT select ON planet_osm_roads TO public;
