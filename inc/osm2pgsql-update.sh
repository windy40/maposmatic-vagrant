#! /bin/bash

cd /home/maposmatic

WORKOSM_DIR=/home/maposmatic/osmosis-diffimport/

if ! test -f $WORKOSM_DIR/state.txt
then
    echo "No OSM import state file found"
    exit 3
fi

cp $WORKOSM_DIR/state.txt $WORKOSM_DIR/state.old

osmosis --read-replication-interval workingDirectory=${WORKOSM_DIR} \
	--simplify-change --write-xml-change $WORKOSM_DIR/changes.xml \
	|| exit 3

if sudo -u maposmatic osm2pgsql \
     --append \
     --slim \
     --database=gis \
     --merc \
     --hstore-all \
     --cache=1000 \
     --number-processes=2 \
     --style=hstore-only.style \
     --tag-transform-script=openstreetmap-carto.lua \
     --prefix=planet_osm_hstore \
     $WORKOSM_DIR/changes.xml
then
    echo "OSM data imported up to $timestamp"
    . $WORKOSM_DIR/state.txt # get timestamp from osmosis state.txt file
    sudo -u maposmatic psql gis -c "update maposmatic_admin set last_update='$timestamp'"
else
    echo "OSM data import failed"
    rm -f $WORKOSM_DIR/changes.xml
    mv $WORKOSM_DIR/state.old $WORKOSM_DIR/state.txt
fi

