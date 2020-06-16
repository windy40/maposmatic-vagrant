#! /bin/bash

cd /home/maposmatic

mkdir -p tools
cd tools

git clone --quiet https://github.com/lonvia/osgende.git
cd osgende
python3 setup.py install

cd ../..
