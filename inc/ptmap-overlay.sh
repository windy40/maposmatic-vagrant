#! /bin/bash

cd /home/maposmatic/styles

mkdir openptmap

cd openptmap

ln -s /home/maposmatic/shapefiles/world_boundaries/ .

wget -r -l 1 -nd -A \*.png -P symbols http://openptmap.org/f/symbols/

wget http://openptmap.org/f/mapnik_pt.xml


# use datasource entity instead of hard coded db parameters
cp /vagrant/files/datasource-settings.xml.inc .

sed -ie 's/<Parameter name="type">postgis<\/Parameter>/\&datasource-settings;/' mapnik_pt.xml

sed -ie '/<Parameter name="host"/d' mapnik_pt.xml
sed -ie '/<Parameter name="port"/d' mapnik_pt.xml
sed -ie '/<Parameter name="user"/d' mapnik_pt.xml
sed -ie '/<Parameter name="password/d' mapnik_pt.xml
sed -ie '/<Parameter name="dbname/d' mapnik_pt.xml

# make style work with standard osm2pgsql style 

sed -ie "s/,bus/,tags->'bus' as bus/" mapnik_pt.xml
sed -ie "s/ bus=/ tags->'bus'=/" mapnik_pt.xml

sed -ie "s/,line/,tags->'line' as line/" mapnik_pt.xml
sed -ie "s/ line=/ tags->'line'=/" mapnik_pt.xml

sed -ie "s/,train/,tags->'train' as train/" mapnik_pt.xml
sed -ie "s/ train=/ tags->'train'=/" mapnik_pt.xml

sed -ie "s/ state=/ tags->'state'=/" mapnik_pt.xml
sed -ie "s/state is null/tags->'state' is null/" mapnik_pt.xml



cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[pt_overlay]
name: Public_Transport_Overlay
group: Transport
description: ptmap Public Transport Overlay
path: /home/maposmatic/styles/openptmap/mapnik_pt.xml

EOF

echo "  pt_overlay," >> /home/maposmatic/ocitysmap/ocitysmap.overlays


