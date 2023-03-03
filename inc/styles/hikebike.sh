#----------------------------------------------------
#
# HikeBikeMap style
#
#----------------------------------------------------

cd $STYLEDIR

git clone --quiet https://github.com/cmarqu/hikebikemap-carto.git

cd hikebikemap-carto/

ln -s $SHAPEFILE_DIR data

# remove deprecated name attributes from layers to silence carto warnings
sed -i '/"name":/d' project.mml

# convert CartoCSS to Mapnil XML
carto --quiet --api $MAPNIK_VERSION_FOR_CARTO project.mml > osm.xml

