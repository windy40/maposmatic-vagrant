#----------------------------------------------------
#
# Fire/Emergency overlay
#
# Original on https://github.com/rweait/Mapnik-fire-overlay
#
#----------------------------------------------------

cd $STYLEDIR

git clone --quiet https://github.com/hholzgra/Mapnik-fire-overlay.git

cd Mapnik-fire-overlay
for f in sql-functions/*.sql
do
    sudo -u maposmatic psql gis < $f
done
cd ..

