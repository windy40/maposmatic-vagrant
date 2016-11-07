#----------------------------------------------------
#
# Humanitarian "HOT" style
#
#----------------------------------------------------

cd /home/maposmatic/styles

git clone https://github.com/hotosm/HDM-CartoCSS.git

cd HDM-CartoCSS

cp -r ../openstreetmap-carto/scripts/ .

sed -e's|/ybon/Data/geo/shp/|/maposmatic/styles/openstreetmap-carto/data/|g' \
    -e's|/ybon/Code/maps/hdm/|/maposmatic/styles/HDM-CartoCSS/|g' \
    -e's|dbname: hdm|dbname: gis|g' \
    -e's|user: osm|user: maposmatic|g' \
    < project.yml > project.yaml

./scripts/yaml2mml.py

carto project.mml > osm.xml

cd DEM
mkdir -p data
./fetch.sh 38,1,40,3 # TODO - this only fetches a small part of Germany
./hillshade.sh
./hillshade_to_vrt.sh
./merge_contour.sh
