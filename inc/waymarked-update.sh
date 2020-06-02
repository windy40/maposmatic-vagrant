#! /bin/bash

cd /home/maposmatic/styles/waymarked-trails-site

IMPORT_SIZE=60

REP_SERVICE=$(cat /home/maposmatic/osm2pgsql-import/replication_url)

PROCESSES=2

echo "== Main DB Update =="
./makedb.py -j $PROCESSES -r $REP_SERVICE -S $IMPORT_SIZE db update || exit
echo

for style in hiking cycling mtb riding skating slopes # running
do
  echo "== $style DB Update =="
  ./makedb.py -j $PROCESSES $style update || exit
  echo
done

psql planet -c "UPDATE waymarked_admin SET last_update=subq.minval FROM (SELECT MIN(status.date::timestamp WITHOUT TIME ZONE) as minval FROM status) subq"

