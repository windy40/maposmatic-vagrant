# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/wily64"

  config.vm.network "forwarded_port", guest: 80, host: 8000

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"
    vb.cpus   = "2"

    # create a 2nd virtual disk as the base box file system isn't large enough
    unless File.exist?('db_disk.vdi')
      vb.customize ['createhd', '--filename', 'db_disk', '--size', 100 * 1024] # 100GB
    end
    vb.customize ['storageattach', :id, '--storagectl', 'SATAController', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', 'db_disk.vdi']
  end

  config.ssh.forward_x11=true

  config.vm.provision "shell", inline: <<-SHELL

#----------------------------------------------------
#
# Vagrant/Virtualbox environment preparations
# (not really Ocitysmap specific yet)
#
#----------------------------------------------------

    # override language settings
    export LANG=en_US.UTF-8
    export LANGUAGE=en_US.UTF-8
    export LC_ADDRESS=en_US.UTF-8
    export LC_ALL=en_US.UTF-8
    export LC_CTYPE=en_US.UTF-8
    export LC_IDENTIFICATION=en_US.UTF-8
    export LC_MEASUREMENT=en_US.UTF-8
    export LC_MESSAGE=en_US.UTF-8
    export LC_MONETARY=en_US.UTF-8
    export LC_NAME=en_US.UTF-8
    export LC_NUMERIC=en_US.UTF-8
    export LC_PAPER=en_US.UTF-8
    export LC_TELEPHONE=en_US.UTF-8
    export LC_TIME=en_US.UTF-8

    # silence curl and wget progress reports
    # as these just flood the vagrant output in an unreadable way
    echo "--silent" > /root/.curlrc
    echo "quiet = on" > /root/.wgetrc

    # pre-seed apt cache to speed things up a bit
    if test -d /vagrant/cache/apt/
    then
      cp -rn /vagrant/cache/apt/ /var/cache/
    fi
  
    # pre-seed compiler cache
    if test -d /vagrant/cache/.ccache/
    then
        cp -rn /vagrant/cache/.ccache/ ~/
    fi

    # create and mount file system on 2nd disk "db_disk"
    if ! test -b /dev/sdb1
    then
      parted /dev/sdb mklabel msdos 
      parted /dev/sdb mkpart primary 512 100%
      mkfs.ext4 -L postgres /dev/sdb1
    fi

    mkdir -p /var/lib/postgresql
    echo 'LABEL=postgres /var/lib/postgresql   ext4   noatime,nobarrier   0   0' >> /etc/fstab
    mount /var/lib/postgresql


#----------------------------------------------------
#
# Install all required packages 
#
#----------------------------------------------------

    # bring apt package database up to date
    apt-get update --quiet=2

    # install needed extra pacakges
    apt-get install --quiet=2 --assume-yes git subversion unzip postgresql postgresql-contrib postgis osm2pgsql python-psycopg2 python-feedparser python-imaging gettext imagemagick ttf-unifont python-cairo python-cairo-dev python-shapely python-gtk2 python-gdal python-rsvg python-pip g++ ccache ttf-dejavu fonts-droid ttf-unifont fonts-sipa-arundina fonts-sil-padauk fonts-khmeros ttf-indic-fonts-core fonts-taml-tscu ttf-kannada-fonts npm gdal-bin node-carto python-yaml apache2 libapache2-mod-wsgi python-django


#----------------------------------------------------
#
# Build Mapnik 2.3.x beta from source
#
# (Mapnik 2.2 has a bug that Ocitysmap runs into,
#  this is also fixed in Mapnik 3.0, but that also
#  changed the python API bindings ...
#
#----------------------------------------------------

    # build and install Mapik 2.3.x from git
    # older Mapnik versions have a bug that leads to Cairo null pointer exceptions
    # and Mapnik 3.0 doesn't have fully working python bindings yet
    apt-get build-dep --quiet=2 --assume-yes python-mapnik
    git clone https://github.com/mapnik/mapnik.git 
    cd mapnik
    git checkout 2.3.x

    # configure, build, install
    export SCONSFLAGS="-j 2"
    python scons/scons.py configure CXX="ccache g++" CC="ccache gcc" SCONSFLAGS=$SCONSFLAGS
    python scons/scons.py
    python scons/scons.py install
    cd ..

#----------------------------------------------------
#
# Set up PostgreSQL and PostGIS 
#
#----------------------------------------------------

    # add "maposmatic" system user that will own the database
    useradd -m maposmatic

    # add "gis" database user
    sudo --user=postgres createuser --superuser --no-createdb --no-createrole maposmatic

    # creade database for osm2pgsql import 
    sudo --user=postgres createdb --encoding=UTF8 --owner=maposmatic gis

    # set up PostGIS for osm2pgsql database
    sudo --user=maposmatic psql --dbname=gis --command="CREATE EXTENSION postgis"
    sudo --user=maposmatic psql --dbname=gis --command="ALTER TABLE geometry_columns OWNER TO maposmatic"
    sudo --user=maposmatic psql --dbname=gis --command="ALTER TABLE spatial_ref_sys OWNER TO maposmatic"

    # set up maposmatic admin table
    sudo --user=maposmatic psql --dbname=gis --command="CREATE TABLE maposmatic_admin (last_update timestamp)"
    sudo --user=maposmatic psql --dbname=gis --command="INSERT INTO maposmatic_admin VALUES ('1970-01-01 00:00:00')"

    # enable hstore extension
    sudo --user=maposmatic psql --dbname=gis --command="CREATE EXTENSION hstore"

    # set password for gis database user
    sudo --user=maposmatic psql --dbname=postgres --command="ALTER USER maposmatic WITH PASSWORD 'secret';"


#----------------------------------------------------
#
# Fetch OCitysMap from GitHub and configure it
#
#----------------------------------------------------

    # install latest ocitysmap from git
    cd /home/maposmatic
    git clone -q https://github.com/hholzgra/ocitysmap.git

    # copy predefined ocitysmap config file to default locations
    cp /vagrant/ocitysmap.conf /home/maposmatic/.ocitysmap.conf
    cp /vagrant/ocitysmap.conf /root/.ocitysmap.conf





#----------------------------------------------------
#----------------------------------------------------
#
# Set up various stylesheets 
#
# When adding stylesheets -> don't forget to register
# them in the ocitysmap.conf file
# 
#----------------------------------------------------
#----------------------------------------------------


#----------------------------------------------------
#
# CartoOsm style sheet - the current OSM default style
#
#----------------------------------------------------

    cd /home/maposmatic
    git clone https://github.com/gravitystorm/openstreetmap-carto.git
    cd openstreetmap-carto
    ./get-shapefiles.sh
    carto project.mml > osm.xml

    # add extra shape file needed by other carto based styles later
    cd data
    wget http://data.openstreetmapdata.com/simplified-land-polygons-complete-3857.zip
    unzip simplified-land-polygons-complete-3857.zip
    wget http://data.openstreetmapdata.com/land-polygons-split-3857.zip
    unzip land-polygons-split-3857.zip
    mkdir ne_10m_populated_places
    cd ne_10m_populated_places
    wget http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_populated_places.zip
    unzip ne_10m_populated_places.zip
    ogr2ogr --config SHAPE_ENCODING UTF8 ne_10m_populated_places_fixed.shp ne_10m_populated_places.shp
    cd ..


#----------------------------------------------------
#
# Fetch old pre-Carto OSM Mapnik stylesheed
#
# we won't really use it as it is outdated, but we need its symbol dir
# for the maposmatic printable stylesheet later
#
#----------------------------------------------------

    cd /home/maposmatic
    svn co -q http://svn.openstreetmap.org/applications/rendering/mapnik mapnik2-osm
    cd mapnik2-osm
    sh ./get-coastlines.sh
    cd world_boundaries/
    ln -s ne_110m_admin_0_boundary_lines_land.shp 110m_admin_0_boundary_lines_land.shp
    ln -s ne_110m_admin_0_boundary_lines_land.dbf 110m_admin_0_boundary_lines_land.dbf



#----------------------------------------------------
#
# MapOSMatic Printable stylesheet
#
#----------------------------------------------------

    cd /home/maposmatic

    # we need to add the MapOSMatic specific
    # symbols to the "old" MapnikOSM symbol set
    cp ocitysmap/stylesheet/maposmatic-printable/symbols/* mapnik2-osm/symbols/

    # configure the actual stylesheet
    cd ocitysmap/stylesheet/maposmatic-printable
    python /home/maposmatic/mapnik2-osm/generate_xml.py --dbname gis \
      --host 'localhost' --user maposmatic --port 5432 --password 'secret' \
      --world_boundaries  /home/maposmatic/mapnik2-osm/world_boundaries \
      --symbols /home/maposmatic/mapnik2-osm/symbols


#----------------------------------------------------
#
# HikeBikeMap style
#
#----------------------------------------------------

    cd /home/maposmatic
    wget -O - https://dl.dropboxusercontent.com/u/279938/hikebikemap-carto-0.9.tbz | tar -xjf -
    cd hikebikemap-carto-0.9/ 
    rm -rf data
    ln -s ../openstreetmap-carto/data/ .
    carto project.mml > osm.xml


#----------------------------------------------------
#
# Humanitarian "HOT" style
#
#----------------------------------------------------

    cd /home/maposmatic
    git clone https://github.com/hotosm/HDM-CartoCSS.git
    cd HDM-CartoCSS
    cp -r ../openstreetmap-carto/scripts/ .
    sed -e's|/ybon/Data/geo/shp/|/maposmatic/openstreetmap-carto/data/|g' \
        -e's|/ybon/Code/maps/hdm/|/maposmatic/HDM-CartoCSS/|g' \
        -e's|dbname: hdm|dbname: gis|g' \
        -e's|user: osm|user: maposmatic|g' \
        < project.yml > project.yaml
    ./scripts/yaml2mml.py
    carto project.mml > osm.xml
    cd DEM
    mkdir -p data
    ./fetch.sh 38,1,40,3 # TODO - this only fetches a small part of Germany
    ./hillshade.sh
    ./hillshade_to_vrt.sh
    ./merge_contour.sh


#----------------------------------------------------
#
# Mapquest EU Stylesheet
#
#----------------------------------------------------

    cd /home/maposmatic

    # fetch current stylesheet version
    git clone git://github.com/MapQuest/MapQuest-Mapnik-Style.git

    cd MapQuest-Mapnik-Style

    # Mapquest stylesheets need the same boundary files as the old
    # MapnikOSM style, so we can just reuse that here
    ln -s /home/maposmatic/mapnik2-osm/world_boundaries world_boundaries

    # fetch additional files required by this style
    cd world_boundaries
    wget http://aweble.de/downloads/mercator_tiffs.tar.bz2
    tar -xvf mercator_tiffs.tar.bz2
    cd ..

    # generate stylesheet XML
    python /home/maposmatic/mapnik2-osm/generate_xml.py \
       --inc mapquest_inc \
       --symbols mapquest_symbols \
       --dbname gis \
       --host 'localhost' \
       --user maposmatic \
       --port 5432 \
       --password secret



#----------------------------------------------------
#
# Golf overlay style 
#
# Original on https://github.com/rweait/Mapnik-golf-overlay
#
#----------------------------------------------------

    cd /home/maposmatic/
    git clone https://github.com/hholzgra/Mapnik-golf-overlay.git



#----------------------------------------------------
#
# Fire/Emergency overlay
#
# Original on https://github.com/rweait/Mapnik-golf-overlay
#
#----------------------------------------------------

    cd /home/maposmatic/
    git clone https://github.com/hholzgra/Mapnik-fire-overlay.git





#----------------------------------------------------
#
# Postprocess all generated style sheets
#
#----------------------------------------------------

find . -name osm.xml | xargs sed -i \
  -e's/background-color="#......"/background-color="#FFFFFF"/g'







#----------------------------------------------------
#
# Import OSM data into database
#
#----------------------------------------------------

    # import data
    sudo --user=maposmatic osm2pgsql --slim --create --database=gis --merc \
      --hstore-all --hstore-match-only --cache=1000 \
      --style=/home/maposmatic/openstreetmap-carto/openstreetmap-carto.style \
      /vagrant/data.osm.pbf

    # update import timestamp
    sudo --user=maposmatic psql --dbname=gis \
      --command="UPDATE maposmatic_admin SET last_update = NOW()"






#----------------------------------------------------
#
# German style
#
# We couldn't set this up earlier together with the
# other stylesheets as it creates some database VIEWS
# that can only be created after the osm2pgsql tables
# have been created ...
#
#----------------------------------------------------
   
    # we share boundaries with the "classic" mapnik OSM style
    # but need to add some extra shape files
    cd /home/maposmatic/mapnik2-osm/world_boundaries
    wget http://data.openstreetmapdata.com/land-polygons-split-3857.zip
    unzip land-polygons-split-3857.zip
    mv land-polygons-split-3857/* .
    wget http://data.openstreetmapdata.com/simplified-land-polygons-complete-3857.zip
    unzip simplified-land-polygons-complete-3857.zip
    mv simplified-land-polygons-complete-3857/* . 
   
    # check out current stylesheet source
    cd /home/maposmatic
    svn checkout http://svn.openstreetmap.org/applications/rendering/mapnik-german/
    cd mapnik-german

    # create some extra database views
    for sql in views/*.sql
    do
      sudo -u maposmatic psql gis < $sql
    done

    # fix a SQL problem in the stylesheet:
    sed -ie "s/ele,'FM9999D99'/ele::float,'FM9999D99'/g" osm-de.xml

    # set up the actual stylesheet
    ../mapnik2-osm/generate_xml.py --host 'localhost' --port 5432 --dbname gis \
          --prefix view_osmde --user maposmatic --password 'secret' \
          --inc $(pwd)/inc-de \
          --world_boundaries /home/maposmatic/mapnik2-osm/world_boundaries \
          osm-de.xml > osm.xml







#----------------------------------------------------
#
# MapOSMatic web frontend installation & configuration
#
#----------------------------------------------------

    # get maposmatic web frontend
    cd /home/maposmatic
    git clone https://github.com/hholzgra/maposmatic.git
    cd maposmatic

    # create needed directories and tweak permissions
    mkdir -p logs rendering/results    

    # copy config files
    cp /vagrant/config.py scripts/config.py
    cp /vagrant/settings.py www/settings.py
    cp /vagrant/settings_local.py www/settings_local.py
    cp /vagrant/maposmatic.wsgi www/maposmatic.wsgi

    # init MaposMatics housekeeping database
    python manage.py makemigrations maposmatic
    python manage.py migrate

    # set up translations
    cd www
    django-admin compilemessages
    cd ..

    # install locales listed in MAP_LANGUAGES in settings.py
    for lang in ar ast by es ca ce da de en es gr hr id it ja fr nl no pl pt ru sk tr uk
    do 
      locale-gen --no-purge --lang $lang
    done 

    # fix directory ownerships
    chown -R maposmatic /home/maposmatic
    chgrp www-data logs www www/datastore.sqlite3
    chmod   g+w    logs www www/datastore.sqlite3

    # set up render daemon
    cp /vagrant/maposmatic-render.service /lib/systemd/system
    chmod 644 /lib/systemd/system/maposmatic-render.service
    systemctl daemon-reload
    systemctl enable maposmatic-render.service
    systemctl start maposmatic-render.service

    # set up web server
    service apache2 stop
    cp /vagrant/000-default.conf /etc/apache2/sites-available
    service apache2 start

#----------------------------------------------------
#
# cleanup
#
#-----------------------------------------------------

    # write back apt cache
    mkdir -p /vagrant/cache
    cp -rn /var/cache/apt/ /vagrant/cache/ 

    # pre-seed compiler cache
    cp -rn /root/.ccache /vagrant/cache/

  SHELL
end
