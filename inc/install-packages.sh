#----------------------------------------------------
#
# Install all required packages 
#
#----------------------------------------------------

# uncomment this when using an old Ubuntu release no longer supported
# sed -i -e's/archive/old-releases/g' /etc/apt/sources.list


# we don't have "banner" installed yet at this point
echo "   ##    #####    #####          #####     ##     ####   #    #    ##     #### "
echo "  #  #   #    #     #            #    #   #  #   #    #  #   #    #  #   #    #"
echo " #    #  #    #     #            #    #  #    #  #       ####    #    #  #     "
echo " ######  #####      #            #####   ######  #       #  #    ######  #  ###"
echo " #    #  #          #            #       #    #  #    #  #   #   #    #  #    #"
echo " #    #  #          #            #       #    #   ####   #    #  #    #   #### "

# prevent configuration dialogs from popping up, we want fully automatic install
export DEBIAN_FRONTEND=noninteractive

# bring apt package database up to date
apt-get update --quiet=2

# install needed extra deb pacakges
apt-get install --quiet=2 --assume-yes \
    apache2 \
    apt-src \
    asciidoctor \
    cabextract \
    cmake \
    coderay \
    curl \
    emacs \
    fonts-arkpandora \
    fonts-droid-fallback \
    fonts-khmeros \
    fonts-noto \
    fonts-noto-color-emoji \
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
    libcairo2-dev \
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
    osm2pgsql \
    osmium-tool \
    osmosis \
    pandoc \
    php-cli \
    php-http-request2 \
    php7.4-xml \
    pngquant \
    poedit \
    postgis \
    postgresql \
    postgresql-contrib \
    postgresql-server-dev-all \
    python3-django \
    python3-future \
    python3-feedparser \
    python3-fiona \
    python3-gdal \
    python3-gi-cairo \
    python3-gpxpy \
    python3-lxml \
    python3-pip \
    python3-pil \
    python3-psycopg2 \
    python3-shapely \
    python3-slugify \
    python3-urllib3 \
    subversion \
    sysvbanner \
    texlive-extra-utils \
    texlive-latex-base \
    texlive-latex-recommended \
    time \
    transifex-client \
    tree \
    ttf-dejavu \
    ttf-unifont \
    unifont \
    unifont-bin \
    unzip \
    wkhtmltopdf \
    > /dev/null

banner "python packages"
pip3 install \
     colour \
     django-cookie-law \
     django-maintenance-mode \
     fastnumbers \
     geoalchemy2 \
     geopy \
     natsort \
     osmium \
     pillow \
     pluginbase \
     pyproj \
     qrcode \
     "sqlalchemy==1.2" \
     "sqlalchemy-utils==0.35" \
     utm \
     > /dev/null

# pip repository version of django-multiupload not compatible with Django 2.1+ yet
pip3 install -e git+https://github.com/Chive/django-multiupload.git#egg=multiupload >/dev/null

# we can't uninstall the Ubuntu python3-pycairo package
# due to too many dependencies, but we need to make sure
# that we actually use the current pip pacakge to get
# support for PDF set_page_label() which the version
# of pycairo that comes with Ubuntu does not have yet
pip3 install --ignore-installed pycairo


# for now on Ubunto Focal we need to install from source packages,
# see https://bugs.launchpad.net/ubuntu/+source/python-mapnik/+bug/1873670

sed -i -e 's/^# deb-src/deb-src/g' /etc/apt/sources.list
apt-get update

mkdir -p /home/maposmatic/build-from-src/python3-mapnik
cd /home/maposmatic/build-from-src/python3-mapnik
apt-get build-dep -y python3-mapnik
apt-src install python3-mapnik
apt-src build python3-mapnik
dpkg -i python3-mapnik*.deb



banner "ruby packages"
gem install --pre asciidoctor-pdf > /dev/null


# install extra npm packages
banner "npm packages"
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs

npm config set loglevel warn

npm install -g carto

# this package is currently broken in Ubuntu, see e.g. 
# https://bugs.launchpad.net/ubuntu/+source/msttcorefonts/+bug/1607535
# so we need to use the working upstream Debian package

banner "ms fonts"
if ! dpkg -i /vagrant/files/ttf-mscorefonts-installer_3.6_all.deb > /dev/null 2>/tmp/ms-fonts.log
then
	cat 1>&2 /tmp/ms-fonts.log
fi



