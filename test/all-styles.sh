#! /bin/bash

for style in $(grep name: ../ocitysmap.conf | grep -v '#' | grep -v 'Overlay' | sed -e 's/name://g')
do
  echo "Testing '$style' style"
  sudo -u maposmatic /home/maposmatic/ocitysmap/render.py --bounding-box=52.0268,8.5274 52.0329,8.5408 --title="Umgebungsplan Test" --format=png --prefix=test-$style  --language=de_DE.utf8 --layout=plain --orientation=landscape --paper-format=A1 --style=$style -C ../ocitysmap.conf > test-$style.log 2> test-$style.err
done
