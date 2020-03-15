#----------------------------------------------------
#
# German CartoOsm style sheet - the current openstreetmap.de style
#
#----------------------------------------------------

cd /home/maposmatic/styles

git clone --quiet https://github.com/giggls/openstreetmap-carto-de.git

cd openstreetmap-carto-de

latest_tag=$(php /vagrant/files/tools/get-latest-tag.php 'v.*-de\d+')

git checkout --quiet v4.24.0-de1

sed -i -e's/dbname: "osm"/dbname: "gis"/' project.mml
sed -i -e's/carto /carto -q /g' Makefile
make

for a in *.xml
do
    php /vagrant/files/tools/postprocess-style.php $a
done

ln -s /home/maposmatic/shapefiles data

