#! /bin/bash

cd $INSTALLDIR

mkdir -p tools
cd tools

apt-get build-dep -y osm2pgsql

git clone --quiet https://github.com/openstreetmap/osm2pgsql.git

cd osm2pgsql

mkdir _build
cd _build

cmake .. >/dev/null
make -j$(nproc) install >/dev/null
