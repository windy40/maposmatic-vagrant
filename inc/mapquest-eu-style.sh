#----------------------------------------------------
#
# Mapquest EU Stylesheet
#
#----------------------------------------------------

cd /home/maposmatic/styles

# fetch current stylesheet version
git clone git://github.com/hholzgra/MapQuest-Mapnik-Style.git

cd MapQuest-Mapnik-Style

# Mapquest stylesheets need the same boundary files as the old
# MapnikOSM style, so we can just reuse that here
ln -s ../mapnik2-osm/world_boundaries world_boundaries

# fetch additional files required by this style
cd world_boundaries
wget http://osm-baustelle.de/mercator_tiffs.tar.bz2
tar -xvf mercator_tiffs.tar.bz2
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

EOF

echo "  mapquest_eu," >> /home/maposmatic/ocitysmap/ocitysmap.styles

