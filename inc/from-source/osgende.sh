#! /bin/bash

cd $INSTALLDIR

mkdir -p tools
cd tools

git clone --quiet https://github.com/waymarkedtrails/osgende.git
cd osgende

git checkout rework-mapdb # see https://github.com/waymarkedtrails/waymarkedtrails-backend/issues/4

python3 setup.py install

cd ../..
