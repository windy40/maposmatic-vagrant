#----------------------------------------------------
#
# HikeBikeMap style
#
#----------------------------------------------------

cd /home/maposmatic/styles

git clone https://github.com/cmarqu/hikebikemap-carto.git

cd hikebikemap-carto/

# we can share the shapefiles with the OSM Carto style
ln -s ../openstreetmap-carto/data/ .

# remove deprecated name attributes from layers to silence carto warnings
sed -i '/"name":/d' project.mml

# convert CartoCSS to Mapnil XML
carto project.mml > osm.xml

cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[hikebikemap]
name: HikeBikeMap
description: HikeBikeMap style
path: /home/maposmatic/styles/hikebikemap-carto/osm.xml

EOF

echo "  hikebikemap," >> /home/maposmatic/ocitysmap/ocitysmap.styles

