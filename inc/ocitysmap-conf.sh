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
echo "  compass_rose," >> /home/maposmatic/.ocitysmap.conf
echo "  scalebar," >> /home/maposmatic/.ocitysmap.conf
echo "  qrcode," >> /home/maposmatic/.ocitysmap.conf

cat /home/maposmatic/ocitysmap/ocitysmap.overlays >> /home/maposmatic/.ocitysmap.conf

cat <<EOF >> /home/maposmatic/.ocitysmap.conf
  surveillance

[scalebar]
name: Scale_Bar_overlay
group: Decoration
description: Scale bar
path: internal:scalebar

[compass_rose]
name: Compass_Rose_overlay
group: Decoration
description: Compass rose
path: internal:compass_rose

[qrcode]
name: QRcode_overlay
group: Decoration
description: QRcode with request URL
path: internal:qrcode

[surveillance]
name: Surveillance_Overlay
group: Special Interest
description: Surveillance Cameras
path: internal:surveillance

EOF

rm -f /root/.ocitysmap.conf
cat /home/maposmatic/ocitysmap/ocitysmap.styledefs >> /home/maposmatic/.ocitysmap.conf
ln -s /home/maposmatic/.ocitysmap.conf /root/.ocitysmap.conf

