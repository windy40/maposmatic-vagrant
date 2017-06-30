#! /bin/bash

PROJECT="/home/maposmatic"
CONFIG="$PROJECT/.ocitysmap.conf"

LAYOUT="single_page_index_side"
ORIENTATION="landscape"

BBOX="52.0100,8.5122 52.0300,8.5432"
PAPER="A1"

BASE_FOR_OVERLAY="CartoOsmBW"

if test $# -gt 0
then
  STYLES=""
  OVERLAYS=""
  while [ $1 ] ; do
    if ( echo $1 | grep -qi Overlay); then
      OVERLAYS="$OVERLAYS $1"
    else
      STYLES="$STYLES $1"
    fi
    shift
  done
else
  STYLES=$(grep name: $CONFIG | grep -v '#' | grep -vi 'Overlay' | sed -e 's/name://g')
  OVERLAYS=$(grep name: $CONFIG | grep -v '#' | grep -i Overlay | sed -e 's/name://g')
fi

for style in $STYLES
do
  echo "Testing '$style' style"
  rm -f test-base-$style*
  for format in png pdf svgz
  do
    base=test-base-$style-$format
    printf "... %-4s " $format
    echo "sudo -u maposmatic $PROJECT/ocitysmap/render.py --config=$CONFIG --bounding-box=$BBOX --title='Test $style ($format)' --format=$format --prefix=$base --language=de_DE.utf8 --layout=$LAYOUT --orientation=$ORIENTATION --paper-format=$PAPER --style=$style" > $base.sh
    chmod a+x $base.sh
    /usr/bin/time -q -f "%E" -o $base.time ./$base.sh > $base.log 2> $base.err
    cat $base.time
  done
  convert test-base-$style-png.png test-base-$style-jpg.jpg
  convert -thumbnail 200 test-base-$style-png.png thumbnails/test-base-$style-png.jpg
done

for overlay in $OVERLAYS
do
  echo "Testing '$overlay' overlay"
  rm -f test-overlay-$overlay*
  for format in png pdf svgz
  do
    base=test-overlay-$overlay-$format
    printf "... %-4s " $format
    echo "sudo -u maposmatic $PROJECT/ocitysmap/render.py --config=$CONFIG --bounding-box=$BBOX --title='Test $overlay ($format)' --format=$format --prefix=$base --language=de_DE.utf8 --layout=$LAYOUT --orientation=$ORIENTATION --paper-format=$PAPER --style='$BASE_FOR_OVERLAY' --overlay=$overlay" > $base.sh
    chmod a+x $base.sh
    /usr/bin/time -q -f "%E" -o $base.time ./$base.sh > $base.log 2> $base.err
    cat $base.time
  done
  convert test-overlay-$overlay-png.png test-overlay-$overlay-jpg.jpg
  convert -thumbnail 200 test-overlay-$overlay-png.png thumbnails/test-overlay-$overlay-png.jpg
done

php index.php > index.html
cd thumbnails
php index.php > index.html

