#! /bin/sh

cat <<EOF > /home/maposmatic/.ocitysmap.conf
[datasource]
host=localhost
user=maposmatic
password=secret
dbname=gis

[rendering]
available_stylesheets:
EOF

cat /home/maposmatic/ocitysmap/ocitysmap.styles >> /home/maposmatic/.ocitysmap.conf

echo "available_overlays:" >> /home/maposmatic/.ocitysmap.conf

cat /home/maposmatic/ocitysmap/ocitysmap.overlays >> /home/maposmatic/.ocitysmap.conf

cat <<EOF >> /home/maposmatic/.ocitysmap.conf
  surveillance

[surveillance]
name: Surveillance_Overlay
description: Surveillance Cameras
path: internal:surveillance

EOF

rm -f /root/.ocitysmap.conf
cat /home/maposmatic/ocitysmap/ocitysmap.styledefs >> /home/maposmatic/.ocitysmap.conf
ln -s /home/maposmatic/.ocitysmap.conf /root/.ocitysmap.conf

