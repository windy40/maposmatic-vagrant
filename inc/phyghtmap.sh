#! /bin/bash

cd /home/maposmatic/

wget http://katze.tfiu.de/projects/phyghtmap/phyghtmap_1.71.orig.tar.gz
tar -xvf phyghtmap_1.71.orig.tar.gz
cd phyghtmap-1.71
python setup.py install
cd ..
