#----------------------------------------------------
#
# Gaslight overlay
#
#----------------------------------------------------

cd $STYLEDIR

git clone --quiet https://github.com/hholzgra/Mapnik-gaslight-overlay.git

cd Mapnik-fire-overlay
for f in sql-functions/*.sql
do
    sudo -u maposmatic psql gis < $f
done
cd ..

