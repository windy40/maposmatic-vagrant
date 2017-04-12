#! /bin/bash

cd /home/maposmatic

apt build-dep osm2pgsql

git clone https://github.com/openstreetmap/osm2pgsql.git

cd osm2pgsql

mkdir _build
cd _build

cmake ..
make install
