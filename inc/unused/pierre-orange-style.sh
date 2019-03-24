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
cd ../ocitysmap/stylesheet/pierre-orange

python /home/maposmatic/styles/mapnik2-osm/generate_xml.py \
       --dbname gis \
       --host 'localhost' \
       --user maposmatic \
       --port 5432 \
       --password 'secret' \
       --world_boundaries /home/maposmatic/shapefiles/world_boundaries \
       --symbols /home/maposmatic/styles/mapnik2-osm/symbols

cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[orange]
name: OrangeStyle
description: Orange style by Pierre Mauduit
path: /home/maposmatic/ocitysmap/stylesheet/pierre-orange/stylesheet.xml
url: http://www.osm-baustelle.de/dokuwiki/style:orange
annotation: Orange style py Pierre Mauduit

EOF

echo "  orange," >> /home/maposmatic/ocitysmap/ocitysmap.styles
