#----------------------------------------------------
# OpenArdenneMap - Belgian topographic map style
#----------------------------------------------------

cd /home/maposmatic/styles
git clone https://github.com/nobohan/OpenArdenneMap
cd OpenArdenneMap

cd osm2pgsql

sed -i -e 's/"osmpg_db"/"gis"/g' -e 's/"..\/..\/..\/Elevation\/contour_anlier.shp"/"..\/contour\/contour.shp"/g' project.mml

carto -a $(mapnik-config -v) --quiet project.mml > OpenArdenneMap.xml

php /vagrant/files/postprocess-style.php OpenArdenneMap.xml

cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[ardenne]
name: OpenArdenneMap
group: Countries
description: OpenArdenneMap topographic style by Julien Minet
path: /home/maposmatic/styles/OpenArdenneMap/osm2pgsql/OpenArdenneMap.xml
url: http://www.osm-baustelle.de/dokuwiki/style:ardenne
annotation: OpenArdenneMap topographic style by Julien Minet

EOF

echo "  ardenne," >> /home/maposmatic/ocitysmap/ocitysmap.styles


