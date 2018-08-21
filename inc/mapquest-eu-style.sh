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
mkdir world_boundaries
cd world_boundaries
for base in shoreline_300 mercator_tiffs world_boundaries processed_p  
do
	for file in /home/maposmatic/shapefiles/$base/*
	do
		ln -s $file .
	done
done
cd ..

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

