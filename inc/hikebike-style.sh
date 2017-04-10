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
sed -i '/name:/d' project.mml

# convert CartoCSS to Mapnil XML
carto project.mml > osm.xml

