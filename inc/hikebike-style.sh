#----------------------------------------------------
#
# HikeBikeMap style
#
#----------------------------------------------------

cd /home/maposmatic/styles

# there doesn't seem to be a public repository for this style? :(
wget -O - https://dl.dropboxusercontent.com/u/279938/hikebikemap-carto-0.9.tbz | tar -xjf -
cd hikebikemap-carto-0.9/ 

# we can share the shapefiles with the OSM Carto style
rm -rf data
ln -s ../openstreetmap-carto/data/ .

# remove deprecated name attributes from layers to silence carto warnings
sed -i '/name:/d' project.mml

# convert CartoCSS to Mapnil XML
carto project.mml > osm.xml

