#! /bin/bash

cd /home/maposmatic

git clone https://github.com/lonvia/osgende.git
cd osgende
python3 setup.py install
cd ..
