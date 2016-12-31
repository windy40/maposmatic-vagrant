#----------------------------------------------------
#
# Install all required packages 
#
#----------------------------------------------------

# bring apt package database up to date
apt-get update --quiet=2


# install needed extra deb pacakges
apt-get install --quiet=2 --assume-yes \
    apache2 \
    cabextract \
    fonts-arkpandora \
    fonts-droid-fallback \
    fonts-khmeros \
    fonts-noto \
    fonts-sil-padauk \
    fonts-sipa-arundina \
    fonts-taml-tscu \
    g++ \
    ccache \
    gdal-bin \
    gettext \
    git \
    imagemagick \
    libapache2-mod-php \
    libapache2-mod-wsgi \
    libkakasi2-dev \
    libmapnik3.0 \
    libmapnik-dev \
    libutf8proc-dev \
    mapnik-utils \
    node-carto \
    npm \
    osm2pgsql \
    osmosis \
    pandoc \
    php-cli \
    postgis \
    postgresql \
    postgresql-contrib \
    postgresql-server-dev-all \
    python-cairo \
    python-cairo-dev \
    python-django \
    python-feedparser \
    python-gdal \
    python-gtk2 \
    python-imaging \
    python-mapnik \
    python-pip \
    python-psycopg2 \
    python-rsvg \
    python-shapely \
    python-yaml \
    subversion \
    ttf-dejavu \
    ttf-unifont \
    unifont \
    unifont-bin \
    unzip \

# install extra python packages 
pip install \
    colour \
    geopy \
    nik4 \

# this package is currently broken in Ubuntu, see e.g. 
# https://bugs.launchpad.net/ubuntu/+source/msttcorefonts/+bug/1607535
# so we need to use the working upstream Debian package

dpkg -i /vagrant/files/ttf-mscorefonts-installer_3.6_all.deb

