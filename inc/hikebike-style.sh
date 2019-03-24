#----------------------------------------------------
#
# HikeBikeMap style
#
#----------------------------------------------------

cd /home/maposmatic/styles

git clone https://github.com/cmarqu/hikebikemap-carto.git

cd hikebikemap-carto/

ln -s /home/maposmatic/shapefiles data

# remove deprecated name attributes from layers to silence carto warnings
sed -i '/"name":/d' project.mml

# convert CartoCSS to Mapnil XML
carto -q -a $(mapnik-config -v) project.mml > osm.xml

cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[hikebikemap]
name: HikeBikeMap
group: Sports
description: HikeBikeMap style
path: /home/maposmatic/styles/hikebikemap-carto/osm.xml
annotation: HikeBikeMap style © Colin Marquardt
url: http://www.osm-baustelle.de/dokuwiki/style:hikebikemap

EOF

echo "  hikebikemap," >> /home/maposmatic/ocitysmap/ocitysmap.styles

