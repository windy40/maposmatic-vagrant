#! /bin/bash

cd $STYLEDIR

git clone https://github.com/giggls/openptmap

cd openptmap

sed -ie 's/>osm</>gis</g' datasource-settings.xml.inc
