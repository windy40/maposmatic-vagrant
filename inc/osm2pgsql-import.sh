#----------------------------------------------------
#
# Import OSM data into database
#
#----------------------------------------------------

FILEDIR=${FILEDIR:-/vagrant/files}

OSM_EXTRACT="${OSM_EXTRACT:-/vagrant/data.osm.pbf}"

cd $INSTALLDIR

mkdir -p osm2pgsql-import
chmod a+w osm2pgsql-import
cd osm2pgsql-import

# get style file

if ! test -f hstore-only.style
then
  wget https://raw.githubusercontent.com/giggls/openstreetmap-carto-de/v4.24.0-de1/hstore-only.style
fi
if ! test -f openstreetmap-carto.lua
then
  wget https://raw.githubusercontent.com/giggls/openstreetmap-carto-de/v4.24.0-de1/openstreetmap-carto.lua
fi

let CacheSize=$MemTotal/3072
echo "osm2pgsql cache size: $CacheSize"

mkdir -p /home/maposmatic/osm-import/
chown maposmatic /home/maposmatic/osm-import/

# import data
time sudo --user=maposmatic osm2pgsql \
     --create \
     --slim \
     --database=gis \
     --merc \
     --hstore-all \
     --cache=$CacheSize \
     --number-processes=$(nproc) \
     --style=hstore-only.style \
     --tag-transform-script=openstreetmap-carto.lua \
     --prefix=planet_osm_hstore \
     --flat-nodes=/home/maposmatic/osm-import/osm2pgsql-nodes.dat \
     --disable-parallel-indexing \
     --keep-coastlines \
     --disable-parallel-indexing \
     --flat-nodes=$INSTALLDIR/osm2pgsql-import/osm2pgsql-nodes.dat \
     --keep-coastlines \
     $OSM_EXTRACT

# install views to provide expected table layouts from hstore-only bas tables

for dir in db_indexes db_functions db_views
do
  for sql in $FILEDIR/database/$dir/*.sql
  do
    sudo -u maposmatic psql gis < $sql
  done
done


# prepare for diff imports
REPLICATION_BASE_URL=$(osmium fileinfo -g 'header.option.osmosis_replication_base_url' "${OSM_EXTRACT}")
if ! test -z "$REPLICATION_BASE_URL"
then
    REPLICATION_SEQUENCE_NUMBER=$(pyosmium-get-changes --start-osm-data ${OSM_EXTRACT})
    REPLICATION_TIMESTAMP=$(osmium fileinfo -g 'header.option.osmosis_replication_timestamp' ${OSM_EXTRACT})

    echo -n $REPLICATION_BASE_URL > replication_url
    echo -n $REPLICATION_SEQUENCE_NUMBER > sequence_number

    cp $FILEDIR/systemd/osm2pgsql-update.* /etc/systemd/system
    chmod 644 /etc/systemd/system/osm2pgsql-update.*
    systemctl daemon-reload
    systemctl enable osm2pgsql-update.timer
    systemctl start osm2pgsql-update.timer
fi

if test -z "$REPLICATION_TIMESTAMP"
then
    # fallback: take timestamp from actual file contents
    REPLICATION_TIMESTAMP=$(osmium fileinfo -e -g data.timestamp.last $OSM_EXTRACT)
fi

sudo -u maposmatic psql gis -c "update maposmatic_admin set last_update='$REPLICATION_TIMESTAMP'"

