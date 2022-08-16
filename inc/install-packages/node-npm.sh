#! /bin/bash

# install extra npm packages
banner "npm packages"
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs

npm config set loglevel warn

npm install -g carto > /dev/null || exit 3
