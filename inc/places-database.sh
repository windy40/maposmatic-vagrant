#! /bin/bash

DBDIR=$CACHEDIR/postgres

mkdir -p $DBDIR

# create places table for replacing nominatim search
if ! test -f $DBDIR/place.sql.gz
then
	wget https://www.osm-baustelle.de/downloads/place.sql.gz -O $DBDIR/place.sql.gz
fi
zcat $DBDIR/place.sql.gz | sudo -u maposmatic psql gis 

sudo -u maposmatic psql gis -c "CREATE INDEX place_osmid_idx ON public.place using btree(osm_id);"
sudo -u maposmatic psql gis -c "CREATE INDEX place_lower ON public.place USING btree (lower((name)::text));"

