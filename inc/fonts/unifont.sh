DOWNLOAD_DIR=${CACHEDIR:-/vagrant/cache}/fonts
mkdir -p $DOWNLOAD_DIR

FONTDIR=/usr/local/share/fonts/truetype/unifont
mkdir -p $FONTDIR

cd $DOWNLOAD_DIR
wget --timestamping https://fontlibrary.org/assets/downloads/gnu-unifont/e4006ef9811d89fcf859c28ae6321f68/gnu-unifont.zip

cd $FONTDIR
unzip -qf $DOWNLOAD_DIR/gnu-unifont.zip

fc-cache -f # not needed for Mapnik, but good practice nonetheless


