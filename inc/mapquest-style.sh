#----------------------------------------------------
#
# Mapquest EU Stylesheet
#
#----------------------------------------------------

cd /home/maposmatic/styles

# fetch current stylesheet version
git clone git://github.com/hholzgra/MapQuest-Mapnik-Style.git

cd MapQuest-Mapnik-Style

# fetch additional files required by this style
ln -s /home/maposmatic/shapefiles/world_boundaries/ .

# generate stylesheet XML
python /home/maposmatic/styles/mapnik2-osm/generate_xml.py \
       --inc mapquest_inc \
       --symbols mapquest_symbols \
       --dbname gis \
       --host 'localhost' \
       --user maposmatic \
       --port 5432 \
       --password secret


cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[mapquest_eu]
name: MapQuestEU
description: MapQuest Europe stylesheet
path: /home/maposmatic/styles/MapQuest-Mapnik-Style/mapquest-eu.xml
annotation: European style © MapQuest

EOF

echo "  mapquest_eu," >> /home/maposmatic/ocitysmap/ocitysmap.styles

