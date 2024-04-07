#! /bin/bash

sudo --user=postgres createuser --role=maposmatic weblate
sudo --user=postgres createdb --encoding=UTF8 --locale=en_US.UTF-8 --template=template0 --owner=weblate weblate
sudo --user=postgres psql --dbname=postgres --command="ALTER USER weblate WITH PASSWORD 'secret';"


mkdir $INSTALLDIR/weblate
cd $INSTALLDIR/weblate

virtualenv .
. bin/activate 

pip install "Weblate[all]"

weblate migrate
weblate createadmin --username admin --password secret --email webmaster@get-map.org 
weblate collectstatic
# weblate compress

lib/python*/site-packages/weblate/examples/celery start
weblate runserver localhost:8080 &
