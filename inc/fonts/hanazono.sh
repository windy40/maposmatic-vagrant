DOWNLOAD_DIR=${CACHEDIR:-/vagrant/cache}/fonts
mkdir -p $DOWNLOAD_DIR

FONTDIR=/usr/local/share/fonts/truetype/hanazono
mkdir -p $FONTDIR

cd $DOWNLOADDIR
# the site had let its certificate expire multiple times
# so we won't check for that here
# see also https://github.com/gravitystorm/openstreetmap-carto/issues/4864
wget --timestamping --no-check-certificate https://osdn.net/frs/redir.php?f=hanazono-font%2F68253%2Fhanazono-20170904.zip -O hanazono.zip

cd $FONTDIR
unzip -oqq "$DOWNLOAD_DIR/hanazono.zip" HanaMinA.ttf HanaMinB.ttf

fc-cache -f
