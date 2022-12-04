#! /bin/bash

### incude local override settings

if test -f ./run-tests-local-config
then
	. ./run-tests-local-config
fi

### default settings

# do not change these here, use the
# run-tests-local-config
# file to set different defaults instead

PROJECT=${PROJECT:-"/home/maposmatic"}
CONFIG=${CONFIG:-"$PROJECT/.ocitysmap.conf"}

LAYOUT=${LAYOUT:-"plain"}
ORIENTATION=${ORIENTATION:-"landscape"}

BBOX=${BBOX:-"52.0100,8.5122 52.0300,8.5432"} # Bielefeld

LANG=${LANG:-"de_DE.utf8"}

PAPER=${PAPER:-"Din A4"}
THUMB_WIDTH=${THUMB_WIDTH:-400}

INDEX=${INDEX:-"Street"}

BASE_FOR_OVERLAY=${BASE_FOR_OVERLAY:-"Empty"}
PREVIEW_DIR=${PREVIEW_DIR:-"/home/maposmatic/maposmatic/www/static/img/"}

PYTHON="python3"


### create reduced size preview images in several resolutions
make_previews () {
    if test -n "$PREVIEW_DIR"
    then
	echo "convert -resize  500x355 $1 $PREVIEW_DIR/$2.png"      >> $3
	echo "convert -resize  750x533 $1 $PREVIEW_DIR/$2-1.5x.png" >> $3
	echo "convert -resize 1000x710 $1 $PREVIEW_DIR/$2-2x.png"   >> $3
    fi
}

make_previews_multi() {
    # TODO use "pdfinfo ... | grep ^Pages:" to find actual PDF page count,
    #      and guess good detail and index page numbers based on that
    #      instead of hard coded pages 5 and 10

    width=$1
    height=$2
    factor=$3

    single_size="${width}x${height}"
    full_size=$(bc <<< "$width*2.5/1")"x"$(bc <<< "$height*1.27/1")
    dw=$(bc <<< "$width/2")
    dh=$(bc <<< "$height/14")
    offset1="+"$(bc <<< "$dw*3")"+"$(bc <<< "$dh*3")
    offset2="+"$(bc <<< "$dw*2")"+"$(bc <<< "$dh*2")
    offset3="+"$dw"+"$dh

    convert layout-multi_page-0.png  -resize $single_size layout-multi_page-title$factor.png
    convert layout-multi_page-2.png  -resize $single_size layout-multi_page-overview$factor.png
    convert layout-multi_page-5.png  -resize $single_size layout-multi_page-detail$factor.png
    convert layout-multi_page-10.png -resize $single_size layout-multi_page-index$factor.png

    convert -size $full_size canvas:white \
            layout-multi_page-index$factor.png     -geometry  $offset1 -composite \
            layout-multi_page-detail$factor.png    -geometry  $offset2 -composite \
            layout-multi_page-overview$factor.png  -geometry  $offset3 -composite \
            layout-multi_page-title$factor.png     -geometry  +0+0     -composite \
            layout-multi_page-all$factor.png

    cp layout-multi_page-all$factor.png $PREVIEW_DIR/layout/multi_page$factor.png
}

### make layout preview
make_layout_preview() {
    layout=$1
    title=$2
    format=$3

    echo -n "$title layout preview ..."
    base="layout-$layout"

    cmd="ocitysmap"
    cmd+=" --config=$CONFIG"
    cmd+=" --bounding-box=$BBOX"
    cmd+=" --title='$title'"
    cmd+=" --prefix='layout-$layout'"
    cmd+=" --layout=$layout"
    cmd+=" --style=CartoOSM"
    cmd+=" --language=$LANG"
    cmd+=" --paper-format='$PAPER'"
    if test "$format" = "pdf"
    then
	cmd+=" --orientation=portrait"
    else
	cmd+=" --orientation=landscape"
    fi
    echo $cmd > $base.sh


    # create previews for single page formats only
    if test "$format" = "png"
    then
       make_previews "$base.png" "layout/$layout" "$base.sh"
    fi

    chmod a+x $base.sh
    /usr/bin/time -q -f "%E" -o $base.time ./$base.sh > $base.log 2> $base.err
    cat $base.time
}

### create actual render command line
make_cmd() {
    base="$1"
    style="$2"
    mode="$3"
    format="$4"

    cmd="ocitysmap"
    cmd+=" --config=$CONFIG"
    cmd+=" --bounding-box=$BBOX"
    cmd+=" --title='Test $style ($format)'"
    cmd+=" --prefix=$base"
    cmd+=" --index=$INDEX"
    cmd+=" --language=$LANG"
    cmd+=" --orientation=$ORIENTATION"
    cmd+=" --paper-format='$PAPER'"
    if [ "$format" == "multi" ]
    then
	cmd+=" --format=pdf"
	cmd+=" --layout=multi_page"
    else
        cmd+=" --format=$format"
	cmd+=" --layout=$LAYOUT"
    fi
    if [ "$mode" == "overlay" ]
    then
	cmd+=" --style='$BASE_FOR_OVERLAY' --overlay=$style"
    else
	cmd+=" --style=$style"
    fi

    echo $cmd
}

# render map in various file formats
make_map() {
    style="$1"
    mode="$2" # base or overlay

    for format in png pdf svgz multi
    do
        base=test-$mode-$style-$format
        printf "... %-4s " $format

	make_cmd $base $style $mode $format >> $base.sh

    if test "$format" == "png"
    then
	make_previews test-base-$style-png.png "style/$style" "$base.sh"
    fi

    chmod a+x $base.sh
    /usr/bin/time -q -f "%E" -o $base.time ./$base.sh > $base.log 2> $base.err
    cat $base.time
  done

  convert test-$mode-$style-png.png test-$mode-$style-jpg.jpg
  convert -thumbnail $THUMB_WIDTH test-$mode-$style-png.png thumbnails/test-$mode-$style-png.jpg

  php index.php > index.html
  ( cd thumbnails && php index.php > index.html )

}


if test $# -gt 0
then
  # get styles to re-render from command line
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
  # with no explicit styles requested we remove and re-render everything
  STYLES=$(grep ^name= $CONFIG | grep -v '#' | grep -vi 'Overlay' | sed -e 's/name=//g' | sort)
  OVERLAYS=$(grep ^name= $CONFIG | grep -v '#' | grep -i 'Overlay' | sed -e 's/name=//g'  | sort)
  rm -rf test-* thumbnails/test-* layout-*
fi

## render

# TODO move preview img generation to own script,
#      enroll different sizes in loop
#      import BBOX and PAPER from common include script

if ! test -f layout-plain.png
then
   make_layout_preview "plain" "Plain" "png"
fi

if ! test -f layout-side-index.png
then
   make_layout_preview "single_page_index_side" "Side index" "png"
fi

if ! test -f layout-bottom-index.png
then
   make_layout_preview "single_page_index_bottom" "Bottom index" "png"
fi

if ! test -f layout-multi_page.png
then
   make_layout_preview "multi_page" "Multi page" "pdf"

   # generating multi page preview image is more tricky

   # generate PNG files for each pdf page
   convert -density 300 layout-multi_page.pdf layout-multi_page.png

   make_previews_multi 200 280 ""
   make_previews_multi 320 420 "-1.5x"
   make_previews_multi 400 560 "-2x"
fi

for style in $STYLES
do
  echo "Testing '$style' style"
  rm -f test-base-$style-*

  make_map $style "base"

  convert test-base-$style-png.png test-base-$style-jpg.jpg
  convert -thumbnail $THUMB_WIDTH test-base-$style-png.png thumbnails/test-base-$style-png.jpg

  php index.php > index.html
  ( cd thumbnails && php index.php > index.html )
done

for style in $OVERLAYS
do
  echo "Testing '$style' overlay"
  rm -f test-overlay-$style-*

  make_map $style "overlay"

  convert test-overlay-$style-png.png test-overlay-$style-jpg.jpg
  convert -thumbnail $THUMB_WIDTH test-overlay-$style-png.png thumbnails/test-overlay-$style-png.jpg

  php index.php > index.html
  ( cd thumbnails && php index.php > index.html )
done


