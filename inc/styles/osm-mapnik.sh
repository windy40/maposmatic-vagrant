#----------------------------------------------------
#
# Fetch old pre-Carto OSM Mapnik stylesheed
#
# we won't really use it as it is outdated, but we need its symbol dir
# for the maposmatic printable stylesheet later
#
#----------------------------------------------------

    cd /home/maposmatic/styles

    svn co -q http://svn.openstreetmap.org/applications/rendering/mapnik mapnik2-osm
    cd mapnik2-osm
    ln -s /home/maposmatic/shapefiles/world_boundaries .

    cd ..

