#! /bin/bash

PROJECT="/home/maposmatic"
CONFIG="$PROJECT/.ocitysmap.conf"

LAYOUT="plain"
ORIENTATION="portrait"

BBOX="52.0100,8.5122 52.0300,8.5432" # Bielefeld

PAPER="Din A4"
THUMB_WIDTH="400"

BASE_FOR_OVERLAY="Empty"
PREVIEW_DIR=/home/maposmatic/maposmatic/www/static/img/

PYTHON="python3"

if test -f ./run-tests-local-config
then
	. ./run-tests-local-config
fi

if test $# -gt 0
then
  STYLES=""
  OVERLAYS=""
  while [ $1 ] ; do
    if ( echo $1 | egrep -q '\s*#' ); then
      echo "Ignoring $1"
      shift
      continue
    elif ( echo $1 | grep -qi Overlay); then
      OVERLAYS="$OVERLAYS $1"
    else
      STYLES="$STYLES $1"
    fi
    shift
  done
else
  STYLES=$(grep ^name= $CONFIG | grep -v '#' | grep -vi 'Overlay' | sed -e 's/name=//g' | sort)
  OVERLAYS=$(grep ^name= $CONFIG | grep -v '#' | grep -i 'Overlay' | sed -e 's/name=//g'  | sort)
  rm -rf test-* thumbnails/test-* layout*

  ## render

  # TODO move preview img generation to own script,
  #      enroll different sizes in loop
  #      import BBOX and PAPER from common include script
  
  echo -n "Plain page layout preview ..."
  base="layout-plain"
  echo "ocitysmap --config=/home/maposmatic/.ocitysmap.conf --bounding-box=$BBOX --title='Plain' --format=png --prefix=layout-plain --language=de_DE.utf8 --layout=plain --orientation=landscape --paper-format='$PAPER' --style=CartoOSM" > $base.sh
  chmod a+x $base.sh
  /usr/bin/time -q -f "%E" -o $base.time ./$base.sh > $base.log 2> $base.err
  convert -resize  500x355 layout-plain.png $PREVIEW_DIR/layout/plain.png
  convert -resize  750x533 layout-plain.png $PREVIEW_DIR/layout/plain-1.5x.png
  convert -resize 1000x710 layout-plain.png $PREVIEW_DIR/layout/plain-2x.png
  cat $base.time

  echo -n "Side index layout preview ..."
  base="layout-side-index"
  echo "ocitysmap --config=/home/maposmatic/.ocitysmap.conf --bounding-box=$BBOX --title='Side Index' --format=png --prefix=layout-side-index --language=de_DE.utf8 --layout=single_page_index_side --orientation=landscape --paper-format='$PAPER' --style=CartoOSM" > $base.sh
  chmod a+x $base.sh
  /usr/bin/time -q -f "%E" -o $base.time ./$base.sh > $base.log 2> $base.err
  cat $base.time
  convert -resize  500x355 layout-side-index.png $PREVIEW_DIR/layout/single_page_index_side.png
  convert -resize  755x533 layout-side-index.png $PREVIEW_DIR/layout/single_page_index_side-1.5x.png
  convert -resize 1000x710 layout-side-index.png $PREVIEW_DIR/layout/single_page_index_side-2x.png

  echo -n "Bottom index layout preview ..."
  base="layout-bottom-index"
  echo "ocitysmap --config=/home/maposmatic/.ocitysmap.conf --bounding-box=$BBOX --title='Bottom Index' --format=png --prefix=layout-bottom-index --language=de_DE.utf8 --layout=single_page_index_bottom --orientation=landscape --paper-format='$PAPER' --style=CartoOSM" > $base.sh
  chmod a+x $base.sh
  /usr/bin/time -q -f "%E" -o $base.time ./$base.sh > $base.log 2> $base.err
  cat $base.time
  convert -resize  500x355 layout-bottom-index.png $PREVIEW_DIR/layout/single_page_index_bottom.png
  convert -resize  750x533 layout-bottom-index.png $PREVIEW_DIR/layout/single_page_index_bottom-1.5x.png
  convert -resize 1000x710 layout-bottom-index.png $PREVIEW_DIR/layout/single_page_index_bottom-2x.png

  echo -n "Multi page layout preview ..."
  base="layout-multi"
  echo "ocitysmap --config=/home/maposmatic/.ocitysmap.conf --bounding-box=$BBOX --title='Multi Page' --format=pdf --prefix=layout-multi --language=de_DE.utf8 --layout=multi_page --orientation=portrait --paper-format='$PAPER' --style=CartoOSM" > $base.sh
  chmod a+x $base.sh
  /usr/bin/time -q -f "%E" -o $base.time ./$base.sh > $base.log 2> $base.err
  cat $base.time

  convert -density 300 layout-multi.pdf layout-multi.png

  convert layout-multi-0.png  -resize 200x280 layout-multi-title.png
  convert layout-multi-2.png  -resize 200x280 layout-multi-overview.png
  convert layout-multi-5.png  -resize 200x280 layout-multi-detail.png
  convert layout-multi-10.png -resize 200x280 layout-multi-index.png

  convert -size 500x355 canvas:white \
            layout-multi-index.png     -geometry  +300+75  -composite \
            layout-multi-detail.png    -geometry  +200+50  -composite \
            layout-multi-overview.png  -geometry  +100+25  -composite \
            layout-multi-title.png     -geometry  +0+0     -composite \
          layout-multi-all.png

  cp layout-multi-all.png $PREVIEW_DIR/layout/multi_page.png

  convert layout-multi-0.png  -resize 300x420 layout-multi-title-1.5x.png
  convert layout-multi-2.png  -resize 300x420 layout-multi-overview-1.5x.png
  convert layout-multi-5.png  -resize 300x420 layout-multi-detail-1.5x.png
  convert layout-multi-10.png -resize 300x420 layout-multi-index-1.5x.png

  convert -size 750x533 canvas:white \
            layout-multi-index-1.5x.png     -geometry  +450+113 -composite \
            layout-multi-detail-1.5x.png    -geometry  +300+75  -composite \
            layout-multi-overview-1.5x.png  -geometry  +150+37  -composite \
            layout-multi-title-1.5x.png     -geometry  +0+0     -composite \
          layout-multi-all-1.5x.png

  cp layout-multi-all-1.5x.png $PREVIEW_DIR/layout/multi_page-1.5x.png

  convert layout-multi-0.png  -resize 400x560 layout-multi-title-2x.png
  convert layout-multi-2.png  -resize 400x560 layout-multi-overview-2x.png
  convert layout-multi-5.png  -resize 400x560 layout-multi-detail-2x.png
  convert layout-multi-10.png -resize 400x560 layout-multi-index-2x.png

  convert -size 1000x710 canvas:white \
            layout-multi-index-2x.png     -geometry  +600+150  -composite \
            layout-multi-detail-2x.png    -geometry  +400+100  -composite \
            layout-multi-overview-2x.png  -geometry  +200+50  -composite \
            layout-multi-title-2x.png     -geometry  +0+0     -composite \
          layout-multi-all-2x.png

  cp layout-multi-all-2x.png $PREVIEW_DIR/layout/multi_page-2x.png
fi

for style in $STYLES
do
  echo "Testing '$style' style"
  for format in png pdf svgz multi
  do
    rm -f test-base-$style-$format.*
  done
  for format in png pdf svgz
  do
    base=test-base-$style-$format
    printf "... %-4s " $format
    echo "ocitysmap --config=$CONFIG --bounding-box=$BBOX --title='Test $style ($format)' --format=$format --prefix=$base --language=de_DE.utf8 --layout=$LAYOUT --orientation=$ORIENTATION --paper-format='$PAPER' --style=$style" > $base.sh
    chmod a+x $base.sh
    /usr/bin/time -q -f "%E" -o $base.time ./$base.sh > $base.log 2> $base.err
    cat $base.time
  done

  base=test-base-$style-multi
  printf "... %-4s " mpdf
  echo "ocitysmap --config=$CONFIG --bounding-box=$BBOX --title='Test $style (multi)' --format=pdf --prefix=$base --language=de_DE.utf8 --layout=multi_page --orientation=portrait --paper-format='Din A4' --style=$style" > $base.sh
  chmod a+x $base.sh
  /usr/bin/time -q -f "%E" -o $base.time ./$base.sh > $base.log 2> $base.err
  cat $base.time
  convert test-base-$style-png.png test-base-$style-jpg.jpg
  convert -thumbnail $THUMB_WIDTH test-base-$style-png.png thumbnails/test-base-$style-png.jpg
  if test -n "$PREVIEW_DIR"
  then
    cp thumbnails/test-base-$style-png.jpg $PREVIEW_DIR/style/$style.jpg
  fi

  php index.php > index.html
  ( cd thumbnails && php index.php > index.html )
done

for overlay in $OVERLAYS
do
  echo "Testing '$overlay' overlay"
  rm -f test-overlay-$overlay*
  for format in png pdf svgz
  do
    base=test-overlay-$overlay-$format
    printf "... %-4s " $format
    echo "ocitysmap --config=$CONFIG --bounding-box=$BBOX --title='Test $overlay ($format)' --format=$format --prefix=$base --language=de_DE.utf8 --layout=$LAYOUT --orientation=$ORIENTATION --paper-format='$PAPER' --style='$BASE_FOR_OVERLAY' --overlay=$overlay" > $base.sh
    chmod a+x $base.sh
    /usr/bin/time -q -f "%E" -o $base.time ./$base.sh > $base.log 2> $base.err
    cat $base.time
  done
  base=test-overlay-$overlay-multi
  printf "... %-4s " mpdf
  echo "ocitysmap --config=$CONFIG --bounding-box=$BBOX --title='Test $overlay (multi)' --format=pdf --prefix=$base --language=de_DE.utf8 --layout=multi_page --orientation=portrait --paper-format='Din A4' --style='$BASE_FOR_OVERLAY' --overlay=$overlay" > $base.sh
  chmod a+x $base.sh
  /usr/bin/time -q -f "%E" -o $base.time ./$base.sh > $base.log 2> $base.err
  cat $base.time
  convert test-overlay-$overlay-png.png test-overlay-$overlay-jpg.jpg
  convert -thumbnail $THUMB_WIDTH test-overlay-$overlay-png.png thumbnails/test-overlay-$overlay-png.jpg
  if test -n "$PREVIEW_DIR"
  then
    cp thumbnails/test-overlay-$overlay-png.jpg $PREVIEW_DIR/overlay/$overlay.jpg
  fi

  php index.php > index.html
  ( cd thumbnails && php index.php > index.html )
done


