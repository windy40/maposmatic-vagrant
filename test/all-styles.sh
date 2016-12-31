#! /bin/bash

rm -f test*

for style in $(grep name: /home/maposmatic/.ocitysmap.conf | grep -v '#' | grep -v 'Overlay' | sed -e 's/name://g')
do
  echo "Testing '$style' style"
  for format in png pdf svgz
  do
    echo "... $format"
    echo "sudo -u maposmatic /home/maposmatic/ocitysmap/render.py --config=/home/maposmatic/.ocitysmap.conf --bounding-box=52.0268,8.5274 52.0329,8.5408 --title='Umgebungsplan Test' --format=$format --prefix=test-$style --language=de_DE.utf8 --layout=plain --orientation=landscape --paper-format=A1 --style=$style" > test-$style-$format.sh
    . test-$style-$format.sh > test-$style-$format.log 2> test-$style-$format.err
  done
done

for overlay in $(grep name: /home/maposmatic/.ocitysmap.conf | grep -v '#' | grep Overlay | sed -e 's/name://g')
do
  echo "Testing '$overlay' overlay"
  for format in png pdf svgz
  do
    echo "... $format"
    echo "sudo -u maposmatic /home/maposmatic/ocitysmap/render.py --config=/home/maposmatic/.ocitysmap.conf --bounding-box=52.0268,8.5274 52.0329,8.5408 --title='Umgebungsplan Test' --format=$format --prefix=test-$overlay --language=de_DE.utf8 --layout=plain --orientation=landscape --paper-format=A1 --style=CartoOSM --overlay=$overlay" > test-$overlay-$format.sh
    . test-$overlay-$format.sh > test-$overlay-$format.log 2> test-$overlay-$format.err
  done
done
