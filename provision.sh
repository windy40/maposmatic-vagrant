#----------------------------------------------------
#
# putting some often used constants into variables
#
#----------------------------------------------------

FILEDIR=/vagrant/files
CACHEDIR=/vagrant/cache
INCDIR=/vagrant/inc

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
if test -d $CACHEDIR/apt/
then
    cp -rn $CACHEDIR/apt/ /var/cache/
fi

# pre-seed compiler cache
if test -d $CACHEDIR/.ccache/
then
    cp -rn $CACHEDIR/.ccache/ ~/
else
    mkdir -p ~/.ccache
fi

# create and mount file system on 2nd disk "db_disk"
if ! test -b /dev/sdc2
then
    parted /dev/sdc rm 1
    parted /dev/sdc mklabel msdos 
    parted /dev/sdc mkpart primary 512 40G     # for /home/maposmatic
    parted /dev/sdc mkpart primary 40G -- -1s  # for /var/lib/postgres
    mkfs.ext4 -L maposmatic  /dev/sdc1
    mkfs.ext4 -L postgres    /dev/sdc2
fi

mkdir -p /home/maposmatic
echo 'LABEL=maposmatic   /home/maposmatic      ext4   noatime,nobarrier   0   0' >> /etc/fstab
mount /home/maposmatic

mkdir -p /var/lib/postgresql
echo 'LABEL=postgres     /var/lib/postgresql   ext4   noatime,nobarrier   0   0' >> /etc/fstab
mount /var/lib/postgresql


. $INCDIR/install-packages.sh

# add "maposmatic" system user that will own the database and all locally installed stuff
useradd maposmatic
chown maposmatic /home/maposmatic

# add host entry for gis-db
sed -ie 's/localhost/localhost gis-db/g' /etc/hosts

# no longer needed with yakkety
# . $INCDIR/mapnik-from-source.sh

. $INCDIR/database-setup.sh

. $INCDIR/osm2pgsql-build.sh
    
. $INCDIR/osm2pgsql-import.sh

. $INCDIR/ocitysmap.sh

. $INCDIR/locales.sh

#----------------------------------------------------
#
# Set up various stylesheets 
#
#----------------------------------------------------

mkdir /home/maposmatic/styles

. $INCDIR/osm-carto-style.sh
. $INCDIR/osm-mapnik-style.sh
. $INCDIR/maposmatic-style.sh
. $INCDIR/hikebike-style.sh
. $INCDIR/humanitarian-style.sh
. $INCDIR/mapquest-eu-style.sh
. $INCDIR/german-style.sh
. $INCDIR/old-german-style.sh
. $INCDIR/pistemap-style.sh
. $INCDIR/osmbright-style.sh
. $INCDIR/opentopomap-style.sh
. $INCDIR/openriverboat-style.sh
. $INCDIR/veloroad-style.sh
. $INCDIR/blossom.sh
. $INCDIR/pencil.sh
. $INCDIR/empty-style.sh

. $INCDIR/golf-overlay.sh
. $INCDIR/fire-overlay.sh
. $INCDIR/maxspeed-overlay.sh
. $INCDIR/ptmap-overlay.sh
. $INCDIR/schwarzkarte-overlay.sh

#----------------------------------------------------
#
# Postprocess all generated style sheets
#
#----------------------------------------------------

. $INCDIR/ocitysmap-conf.sh

cd /home/maposmatic/styles
find . -name osm.xml | xargs \
    sed -i -e's/background-color="#......"/background-color="#FFFFFF"/g'


. $INCDIR/maposmatic-frontend.sh

#----------------------------------------------------
#
# tests
#
#-----------------------------------------------------

cd /vagrant/test
./run-tests.sh

#----------------------------------------------------
#
# cleanup
#
#-----------------------------------------------------

# write back apt cache
mkdir -p $CACHEDIR
cp -rn /var/cache/apt/ $CACHEDIR 

# pre-seed compiler cache
cp -rn /root/.ccache $CACHEDIR

