#----------------------------------------------------
#
# German CartoOsm style sheet - the current openstreetmap.de style
#
#----------------------------------------------------

cd /home/maposmatic/styles

git clone https://github.com/hholzgra/openstreetmap-carto-de.git

cd openstreetmap-carto-de
git checkout maposmatic

touch project.yaml
make
ln -s ../openstreetmap-carto/data .
for sql_file in osm_tag2num.sql views_osmde/view-*.sql
do
    sudo -u maposmatic psql -d gis -f $sql_file
done 
