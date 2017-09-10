#! /bin/bash

cd /home/maposmatic/styles

git clone https://github.com/flickr/Pandonia
cd Pandonia 

cp ../blossom/project.mml .

sed '/"name":/d' < project.mml > osm.mml
carto -a 3.0.12 -l osm.mml | sed -e 's/\[osm\]/\[gis\]/g' > osm.xml

cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[pandonia]
name: Pandonia
description: Pandonia style by Flickr
path: /home/maposmatic/styles/Pandonia/osm.xml

EOF

echo "  pandonia," >> /home/maposmatic/ocitysmap/ocitysmap.styles

