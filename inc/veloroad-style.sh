#! /bin/bash

cd /home/maposmatic/styles/

git clone https://github.com/hholzgra/veloroad.git
cd veloroad
git checkout hstore

./get-shapefiles.sh

carto project.mml > veloroad.xml

