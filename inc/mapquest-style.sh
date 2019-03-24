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

python /home/maposmatic/styles/mapnik2-osm/generate_xml.py \
       --inc hybrid_inc \
       --symbols hybrid_symbols \
       --dbname gis \
       --host 'localhost' \
       --user maposmatic \
       --port 5432 \
       --password secret


cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[mapquest_eu]
name: MapQuestEU
group: MapQuest
description: MapQuest Europe stylesheet
path: /home/maposmatic/styles/MapQuest-Mapnik-Style/mapquest-eu.xml
annotation: European style © MapQuest

[mapquest_uk]
name: MapQuestUK
group: MapQuest
description: MapQuest UK stylesheet
path: /home/maposmatic/styles/MapQuest-Mapnik-Style/mapquest-uk.xml
annotation: UK style © MapQuest

[mapquest_us]
name: MapQuestUS
group: MapQuest
description: MapQuest USA stylesheet
path: /home/maposmatic/styles/MapQuest-Mapnik-Style/mapquest-us.xml
annotation: USA style © MapQuest

[mapquest_hybrid_eu]
name: MapQuestEU
group: MapQuest
description: MapQuest Europe hybrid stylesheet
path: /home/maposmatic/styles/MapQuest-Mapnik-Style/mapquest-hybrideu.xml
annotation: European hybrid style © MapQuest

[mapquest_hybrid_uk]
name: MapQuestUK
group: MapQuest
description: MapQuest UK hybrid stylesheet
path: /home/maposmatic/styles/MapQuest-Mapnik-Style/mapquest-hybriduk.xml
annotation: UK hybrid style © MapQuest

[mapquest_hybrid_us]
name: MapQuestUS
group: MapQuest
description: MapQuest USA hybrid stylesheet
path: /home/maposmatic/styles/MapQuest-Mapnik-Style/mapquest-hybridus.xml
annotation: USA hybrid style © MapQuest

EOF

echo "  mapquest_eu," >> /home/maposmatic/ocitysmap/ocitysmap.styles
echo "  mapquest_uk," >> /home/maposmatic/ocitysmap/ocitysmap.styles
echo "  mapquest_us," >> /home/maposmatic/ocitysmap/ocitysmap.styles
echo "  mapquest_hybrid_eu," >> /home/maposmatic/ocitysmap/ocitysmap.styles
echo "  mapquest_hybrid_uk," >> /home/maposmatic/ocitysmap/ocitysmap.styles
echo "  mapquest_hybrid_us," >> /home/maposmatic/ocitysmap/ocitysmap.styles

