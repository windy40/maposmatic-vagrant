#! /bin/bash

useradd --create-home --home-dir=$INSTALLDIR/weblate weblate
usermod -a -G www-data weblate

sudo --user=postgres createuser --role=maposmatic weblate
sudo --user=postgres createdb --encoding=UTF8 --locale=en_US.UTF-8 --template=template0 --owner=weblate weblate
sudo --user=postgres psql --dbname=postgres --command="ALTER USER weblate WITH PASSWORD 'secret';"


cd $INSTALLDIR/weblate

virtualenv .
. bin/activate 

pip install "Weblate[all]"

PYTHON_VERSION=python$(python3 -c 'import sys; print("%d.%d" % (sys.version_info.major, sys.version_info.minor))')

PYTHON_DIR="$PWD/lib/$PYTHON_VERSION"
PYTHON_PKG_DIR="$PYTHON_DIR/site-packages"
WEBLATE_PKG_DIR="$PYTHON_PKG_DIR/weblate"

echo "PYTHON_VERSION: $PYTHON_VERSION"
echo "PYTHON_DIR: $PYTHON_DIR"
echo "PYTHON_PKG_DIR: $PYTHON_PKG_DIR"
echo "WEBLATE_PKG_DIR: $WEBLATE_PKG_DIR"

ls -l "$FILEDIR/config-files/weblate_settings.py"
ls -l "$WEBLATE_PKG_DIR/settings.py"

sed -e"s|@INSTALLDIR@|$INSTALLDIR|g" \
  < $FILEDIR/config-files/weblate_settings.py \
  > $WEBLATE_PKG_DIR/settings.py

ls -l "$FILEDIR/config-files/weblate_settings.py"
ls -l "$WEBLATE_PKG_DIR/settings.py"

weblate migrate
weblate createadmin --username admin --password secret --email webmaster@get-map.org 
weblate collectstatic
# weblate compress

$WEBLATE_PKG_DIR/examples/celery start

chown -R weblate .

mkdir -p data/cache
chown -R weblate:www-data data
chmod -R ug+rwx data

mkdir -p logs
chown weblate:www-data logs
chmod ug+rwx logs

sed -e"s|@INSTALLDIR@|$INSTALLDIR|g" \
    -e"s|@WEBLATE_PKG_DIR@|$WEBLATE_PKG_DIR|g" \
  < $FILEDIR/config-files/a2site-weblate.conf \
  > /etc/apache2/sites-available/weblate.conf

a2ensite weblate
systemctl restart apache2

deactivate
