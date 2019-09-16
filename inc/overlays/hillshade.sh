#! /bin/bash

mkdir -p /home/maposmatic/styles/hillshade-overlay
cd /home/maposmatic/styles/hillshade-overlay

cp /vagrant/files/styles/hillshade.xml .
ln -s /home/maposmatic/elevation-data/dem .
