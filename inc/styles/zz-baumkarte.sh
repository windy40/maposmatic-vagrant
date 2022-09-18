#! /bin/bash

cd $STYLEDIR

git clone --quiet https://github.com/rudzick/Mymapnik.git baumkarte
cd baumkarte

rm -f /usr/local/bin/carto
ln /usr/bin/carto /usr/local/bin/carto

cp Baumsorten_Erweiterung/my_mms-files.mml Baumsorten_Erweiterung/my_mms-files_cwd.mml

( cd ../openstreetmap-carto/; ln -s ../baumkarte/Baumsorten_Erweiterung . )

./mymapnik.bash /home/maposmatic/styles/openstreetmap-carto


