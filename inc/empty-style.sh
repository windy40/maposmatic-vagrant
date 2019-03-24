#! /bin/bash

cd /home/maposmatic/styles

mkdir empty
cd empty
cp /vagrant/files/empty.xml .

cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[empty]
name: Empty
group: Low Contrast
description: Empty basemap for overlay testing
url: http://www.osm-baustelle.de/dokuwiki/style:empty
path: /home/maposmatic/styles/empty/empty.xml

EOF

echo "  empty" >> /home/maposmatic/ocitysmap/ocitysmap.styles
