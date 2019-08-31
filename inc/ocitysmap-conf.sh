#! /bin/sh

cat <<EOF > /home/maposmatic/.ocitysmap.conf
[datasource]
host=localhost
user=maposmatic
password=secret
dbname=gis

[paper_sizes]
Din A4: 210x297
Din A3: 297x420
Din A2: 420x594
Din A1: 594x841
Din A0: 841x1189
2x A0: 1189x1682
US letter: 216x279

[multipage_paper_sizes]
Din A4: 210x297
US letter: 216x279

[rendering]
available_stylesheets:
EOF

cat /home/maposmatic/ocitysmap/ocitysmap.styles >> /home/maposmatic/.ocitysmap.conf

echo "available_overlays:" >> /home/maposmatic/.ocitysmap.conf
echo "  compass_rose," >> /home/maposmatic/.ocitysmap.conf
echo "  scalebar," >> /home/maposmatic/.ocitysmap.conf
echo "  osm_notes," >> /home/maposmatic/.ocitysmap.conf
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

[osm_notes]
name: OSM_Notes_Overlay
group: Special Interest
description: OSM Notes Overlay
path: internal:osm_notes


EOF

rm -f /root/.ocitysmap.conf
cat /home/maposmatic/ocitysmap/ocitysmap.styledefs >> /home/maposmatic/.ocitysmap.conf
ln -s /home/maposmatic/.ocitysmap.conf /root/.ocitysmap.conf

