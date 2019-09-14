#! /bin/bash

cd /home/maposmatic/styles

git clone --quiet https://github.com/hholzgra/mapbox-studio-pencil.tm2.git
cd mapbox-studio-pencil.tm2
git checkout --quiet dev-osm2pgsql

