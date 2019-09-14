#----------------------------------------------------
#
# Fire/Emergency overlay
#
# Original on https://github.com/rweait/Mapnik-golf-overlay
#
#----------------------------------------------------

cd /home/maposmatic/styles

git clone https://github.com/hholzgra/Mapnik-fire-overlay.git

cd Mapnik-fire-overlay
for f in sql-functions/*.sql
do
    sudo -u maposmatic psql gis < $f
done
cd ..

