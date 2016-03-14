# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/wily64"

  config.vm.network "forwarded_port", guest: 8000, host: 8000

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.cpus   = "2"

    # create a 2nd virtual disk as the base box file system isn't large enough
    unless File.exist?('db_disk.vdi')
      vb.customize ['createhd', '--filename', 'db_disk', '--size', 100 * 1024] # 100GB
    end
    vb.customize ['storageattach', :id, '--storagectl', 'SATAController', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', 'db_disk.vdi']
  end

  config.ssh.forward_x11=true

  config.vm.provision "shell", inline: <<-SHELL
    # override language settings
    export LANG=en_US.utf8
    export LANGUAGE=en_US.utf8
    export LC_ADDRESS=en_US.UTF-8
    export LC_ALL=en_US.utf8
    export LC_CTYPE=en_US.utf8
    export LC_IDENTIFICATION=en_US.UTF-8
    export LC_MEASUREMENT=en_US.UTF-8
    export LC_MESSAGE=en_US.utf8
    export LC_MONETARY=en_US.UTF-8
    export LC_NAME=en_US.UTF-8
    export LC_NUMERIC=en_US.UTF-8
    export LC_PAPER=en_US.UTF-8
    export LC_TELEPHONE=en_US.UTF-8
    export LC_TIME=en_US.UTF-8

    # create and mount file system on 2nd disk "db_disk"

    if [ ! test -b /dev/sda1 ]
    then
      parted /dev/sdb mklabel msdos 
      parted /dev/sdb mkpart primary 512 100%
      mkfs.ext4 -l postgres /dev/sdb1
    fi

    mkdir -p /var/lib/postgresql
    echo `blkid /dev/sdb1 | awk '{print$2}' | sed -e 's/"//g'` /var/lib/postgresql   ext4   noatime,nobarrier   0   0 >> /etc/fstab
    mount /var/lib/postgresql

    # bring apt package database up to date
    apt-get update --quiet

    # install needed extra pacakges
    apt-get install --quiet --assume-yes git subversion unzip postgresql postgresql-contrib postgis osm2pgsql python-psycopg2 python-feedparser python-imaging gettext imagemagick ttf-unifont python-cairo python-cairo-dev python-shapely python-gtk2 python-gdal python-rsvg python-pip g++ ccache ttf-dejavu fonts-droid ttf-unifont fonts-sipa-arundina fonts-sil-padauk fonts-khmeros ttf-indic-fonts-core fonts-taml-tscu ttf-kannada-fonts npm gdal-bin node-carto python-yaml

    # install right version of Django
    pip install django==1.3.7

    # build and install Mapik 2.3.x from git
    # older Mapnik versions have a bug that leads to Cairo null pointer exceptions
    # and Mapnik 3.0 doesn't have fully working python bindings yet
    apt-get build-dep --quiet --assume-yes python-mapnik
    git clone https://github.com/mapnik/mapnik.git 
    cd mapnik
    git checkout 2.3.x

    # scons build defaults
    export SCONSFLAGS="-j 2"
    export CC="ccache gcc"
    export CXX="ccache g++"

    # configure, build, install
    python scons/scons.py configure CXX="ccache g++" CC="ccache gcc" 
    python scons/scons.py
    python scons/scons.py install
    cd ..

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

    # enable hstore extension
    sudo --user=maposmatic psql --dbname=gis --command="CREATE EXTENSION hstore"

    # set password for gis database user
    sudo --user=maposmatic psql --dbname=postgres --command="ALTER USER maposmatic WITH PASSWORD 'secret';"

    # fetch and prepare default (old) mapnik OSM rendering style
    # we won't really use it as it is outdated, but we need its symbol dir
    # for the maposmatic printable stylesheet later
    cd /home/maposmatic
    svn co -q http://svn.openstreetmap.org/applications/rendering/mapnik mapnik2-osm

    # carto osm style
    cd /home/maposmatic
    git clone https://github.com/gravitystorm/openstreetmap-carto.git
    cd openstreetmap-carto
    ./get-shapefiles.sh
    carto project.mml > osm.xml     

    # install latest ocitysmap from git
    cd /home/maposmatic
    git clone -q https://github.com/hholzgra/ocitysmap.git

    # set up maposmatic printable stylesheet
    cp ocitysmap/stylesheet/maposmatic-printable/symbols/* mapnik2-osm/symbols/
    cd mapnik2-osm 
    python /home/maposmatic/mapnik2-osm/generate_xml.py --dbname gis --host 'localhost' --user maposmatic --port 5432 --password 'secret' --world_boundaries  /home/maposmatic/mapnik2-osm/world_boundaries --symbols /home/maposmatic/mapnik2-osm/symbols 
    cd mapnik2-osm/world_boundaries/
    ln -s ne_110m_admin_0_boundary_lines_land.shp 110m_admin_0_boundary_lines_land.shp 

    # copy predefined ocitysmap config file to default locations
    cp /vagrant/ocitysmap.conf /home/maposmatic/.ocitysmap.conf
    cp /vagrant/ocitysmap.conf /root/.ocitysmap.conf

    # import OSM data into database
    sudo --user=maposmatic osm2pgsql --slim --create --database=gis --merc --hstore --cache=1000 --style=/home/maposmatic/openstreetmap-carto/openstreetmap-carto.style /vagrant/data.osm.pbf

    # get maposmatic web frontend
    cd /home/maposmatic
    git clone https://github.com/hholzgra/maposmatic.git
    cd maposmatic

    # create needed directories
    mkdir -p logs rendering/results    

    # copy config files
    cp /vagrant/config.py scripts/config.py
    cp /vagrant/settings.py www/settings.py
    cp /vagrant/settings_local.py www/settings_local.py
    cp /vagrant/maposmatic.wsgi www/maposmatic.wsgi

    # init MaposMatics housekeeping database
    python www/manage.py syncdb

    # set up translations
    cd www
    django-admin.py compilemessages
    cd ..

    # install locales listed in MAP_LANGUAGES in settings.py
    for lang in ar ast by es ca ce da de en es gr hr id it ja fr nl no pl pt ru sk tr uk
    do 
      locale-gen --no-purge --lang $lang
    done 

    # FIXME: just make everything writable for now
    chown -R maposmatic /home/maposmatic
    chmod -R a+w        /home/maposmatic

    # set up render daemon and web server
    cp /vagrant/maposmatic*.service /lib/systemd/system
    chmod 644 /lib/systemd/system/maposmatic*.service
    systemctl daemon-reload
    systemctl enable maposmatic-render.service maposmatic-web.service
    systemctl start maposmatic-render.service maposmatic-web.service

  SHELL
end
