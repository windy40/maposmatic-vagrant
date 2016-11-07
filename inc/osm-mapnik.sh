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
    sh ./get-coastlines.sh
    cd world_boundaries/
    ln -s ne_110m_admin_0_boundary_lines_land.shp 110m_admin_0_boundary_lines_land.shp
    ln -s ne_110m_admin_0_boundary_lines_land.dbf 110m_admin_0_boundary_lines_land.dbf

    cd ..

