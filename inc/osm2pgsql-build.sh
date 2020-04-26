#! /bin/bash

cd /home/maposmatic/tools

apt-get build-dep osm2pgsql

git clone --quiet https://github.com/openstreetmap/osm2pgsql.git

cd osm2pgsql

mkdir _build
cd _build

cmake .. >/dev/null
make -j$(nproc) install >/dev/null
