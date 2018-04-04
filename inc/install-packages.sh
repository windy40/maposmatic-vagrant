#----------------------------------------------------
#
# Install all required packages 
#
#----------------------------------------------------

sed -i -e's/[a-z.]*archive/old-releases/g' /etc/apt/sources.list

# bring apt package database up to date
apt-get update --quiet=2


# install needed extra deb pacakges
apt-get install --quiet=2 --assume-yes \
    apache2 \
    cabextract \
    cmake \
    curl \
    emacs \
    fonts-arkpandora \
    fonts-droid-fallback \
    fonts-khmeros \
    fonts-noto \
    fonts-sil-padauk \
    fonts-sipa-arundina \
    fonts-taml-tscu \
    g++ \
    gir1.2-pango-1.0 \
    gir1.2-rsvg-2.0 \
    ccache \
    gdal-bin \
    gettext \
    git \
    imagemagick \
    libapache2-mod-php \
    libapache2-mod-wsgi-py3 \
    libboost-python-dev \
    libbz2-dev \
    libgdal-dev \
    libkakasi2-dev \
    liblua5.3-dev \
    libmapnik3.0 \
    libmapnik-dev \
    libosmium2-dev \
    libpython3-dev \
    libutf8proc-dev \
    mapnik-utils \
    mc \
    npm \
    osm2pgsql \
    osmosis \
    pandoc \
    php-cli \
    pngquant \
    poedit \
    postgis \
    postgresql \
    postgresql-contrib \
    postgresql-server-dev-all \
    python-beautifulsoup \
    python-cairo \
    python-cairo-dev \
    python-feedparser \
    python-future \
    python-gdal \
    python-gtk2 \
    python-imaging \
    python-mapnik \
    python-matplotlib \
    python-pip \
    python-psycopg2 \
    python-rsvg \
    python-shapely \
    python-yaml \
    python3-django \
    python3-future \
    python3-feedparser \
    python3-gdal \
    python3-gi-cairo \
    python3-mapnik \
    python3-pip \
    python3-psycopg2 \
    python3-shapely \
    python3-slugify \
    python3-sqlalchemy \
    python3-urllib3 \
    subversion \
    sysvbanner \
    time \
    transifex-client \
    tree \
    ttf-dejavu \
    ttf-unifont \
    unifont \
    unifont-bin \
    unzip \

# install extra python packages 
banner "pip packages"
pip install \
    colour \
    django-bootstrap3 \
    geopy \
    nik4 \
    osmium \
    pluginbase \
    qrcode \

pip3 install \
     colour \
     geoalchemy2 \
     geopy \
     pillow \
     pluginbase \
     osmium \
     qrcode \
     sqlalchemy-utils \
     natsort \
     fastnumbers \

# install extra npm packages
banner "npm packages"
(cd /usr/local/bin; ln -s /usr/bin/nodejs node)
npm config set loglevel warn

npm install -g \
    bower \
    @mapbox/carto \
    millstone

# this package is currently broken in Ubuntu, see e.g. 
# https://bugs.launchpad.net/ubuntu/+source/msttcorefonts/+bug/1607535
# so we need to use the working upstream Debian package

banner "ms fonts"
dpkg -i /vagrant/files/ttf-mscorefonts-installer_3.6_all.deb



