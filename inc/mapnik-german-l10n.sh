#-------------------------------------------------------
#
# contrib extensions required by osml10n extension
#
#--------------------------------------------------------

sudo --user=maposmatic psql --dbname=gis --command="CREATE EXTENSION fuzzystrmatch"
sudo --user=maposmatic psql --dbname=gis --command="CREATE EXTENSION unaccent"

#----------------------------------------------------------
#
# osml10n extension for PostgreSQL required by german style
#
#----------------------------------------------------------

cd /home/maposmatic

mkdir -p tools
cd tools

git clone --quiet https://github.com/giggls/mapnik-german-l10n.git
cd mapnik-german-l10n
make install
sudo --user=maposmatic psql --dbname=gis --command="CREATE EXTENSION osml10n"

cd ..

