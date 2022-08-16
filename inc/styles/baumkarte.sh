#! /bin/bash

cd $STYLEDIR

git clone --quiet https://github.com/rudzick/Mymapnik.git baumkarte
cd baumkarte

ln /usr/bin/carto /usr/local/bin/carto

./mymapnik.bash /home/maposmatic/styles/openstreetmap-carto


