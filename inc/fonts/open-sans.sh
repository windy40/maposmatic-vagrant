DOWNLOAD_DIR=${CACHEDIR:-/vagrant/cache}/fonts
mkdir -p $DOWNLOAD_DIR

FONTDIR=/usr/local/share/fonts/truetype/open-sans
mkdir -p $FONTDIR

cd $DOWNLOAD_DIR
wget --timestamping https://www.cufonfonts.com/download/font/open-sans -O open-sans.zip

cd $FONTDIR
unzip $DOWNLOAD_DIR/open-sans.zip

fc-cache -f # not needed for Mapnik, but good practice nonetheless


