#----------------------------------------------------
#
# Humanitarian "HOT" style
#
#----------------------------------------------------

cd /home/maposmatic/styles

git clone https://github.com/hholzgra/HDM-CartoCSS.git

cd HDM-CartoCSS

git checkout nohillshade

sed -e's|/ybon/Data/geo/shp/|/maposmatic/styles/openstreetmap-carto/data/|g' \
    -e's|/ybon/Code/maps/hdm/|/maposmatic/styles/HDM-CartoCSS/|g' \
    -e's|dbname: hdm|dbname: gis|g' \
    -e's|user: osm|user: maposmatic|g' \
    < project.yml > project.mml

carto project.mml > osm.xml


# cd DEM
# mkdir -p data
# ./fetch.sh 38,1,40,3 # TODO - this only fetches a small part of Germany
# ./hillshade.sh
# ./hillshade_to_vrt.sh
# ./merge_contour.sh

cat <<EOF >> /home/maposmatic/ocitysmap/ocitysmap.styledefs
[humanitarian]
name: Humanitarian
description: HOT Humanitarian style
path: /home/maposmatic/styles/HDM-CartoCSS/osm.xml

EOF

echo "  humanitarian," >> /home/maposmatic/ocitysmap/ocitysmap.styles

