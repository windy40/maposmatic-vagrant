#! /bin/bash

cd $STYLEDIR

git clone https://github.com/giggls/openptmap

cd openptmap

sed -ie 's/>osm</>gis</g' datasource-settings.xml.inc

for sql in views/*.sql
do
	psql gis < $sql
done
