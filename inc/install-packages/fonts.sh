#! /bin/bash

# download / install extra fonts
banner "extra fonts"
(cd $INCDIR/fonts; for script in *.sh; do basename $script ".sh"; ( . $script ); done )

echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections

    ttf-mscorefonts-installer \
