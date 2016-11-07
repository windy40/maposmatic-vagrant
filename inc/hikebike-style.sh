#----------------------------------------------------
#
# HikeBikeMap style
#
#----------------------------------------------------

cd /home/maposmatic/styles

wget -O - https://dl.dropboxusercontent.com/u/279938/hikebikemap-carto-0.9.tbz | tar -xjf -
cd hikebikemap-carto-0.9/ 
rm -rf data
ln -s ../openstreetmap-carto/data/ .
carto project.mml > osm.xml


