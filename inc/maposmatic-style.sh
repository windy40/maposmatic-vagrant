#----------------------------------------------------
#
# MapOSMatic Printable stylesheet
#
#----------------------------------------------------

cd /home/maposmatic/styles

# we need to add the MapOSMatic specific
# symbols to the "old" MapnikOSM symbol set
cp ../ocitysmap/stylesheet/maposmatic-printable/symbols/* mapnik2-osm/symbols/

# configure the actual stylesheet
cd ../ocitysmap/stylesheet/maposmatic-printable

python3 /home/maposmatic/styles/mapnik2-osm/generate_xml.py \
       --dbname gis \
       --host 'localhost' \
       --user maposmatic \
       --port 5432 \
       --password 'secret' \
       --world_boundaries /home/maposmatic/styles/mapnik2-osm/world_boundaries \
       --symbols /home/maposmatic/styles/mapnik2-osm/symbols

cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[maposmatic]
name: Maposmatic
description: The Maposmatic printable stylesheet
path: /home/maposmatic/ocitysmap/stylesheet/maposmatic-printable/osm.xml
url: http://www.osm-baustelle.de/dokuwiki/style:maposmatic
annotation: MapOSMatic printable style © MapOSMatic developers

EOF

echo "  maposmatic," >> /home/maposmatic/ocitysmap/ocitysmap.styles
