CREATE OR REPLACE VIEW planet_osm_rels AS
SELECT * FROM planet_osm_hstore_rels;

GRANT select ON planet_osm_rels TO public;

