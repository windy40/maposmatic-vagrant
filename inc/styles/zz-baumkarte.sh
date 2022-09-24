#! /bin/bash

cd $STYLEDIR

git clone --quiet https://github.com/rudzick/Mymapnik.git baumkarte
cd baumkarte

(cd /usr/local/bin/; rm -f carto; ln -s /usr/bin/carto .)

cp Baumsorten_Erweiterung/my_mms-files.mml Baumsorten_Erweiterung/my_mms-files_cwd.mml

( cd ../openstreetmap-carto/; ln -s ../baumkarte/Baumsorten_Erweiterung . )

./mymapnik.bash /home/maposmatic/styles/openstreetmap-carto

sudo -u maposmatic psql gis < $INCDIR/styles/zz-baumkarte.sql

