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
    fonts-droid-fallback \
    fonts-khmeros \
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
    libutf8proc-dev \
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
    python-pip \
    python-psycopg2 \
    python-rsvg \
    python-shapely \
    python-yaml \
    subversion \
    ttf-dejavu \
    ttf-unifont \
    unzip \

# install extra python packages 
pip install \
    colour \
    geopy \
    nik4 \
