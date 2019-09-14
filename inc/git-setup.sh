#! /bin/bash

if test -f /vagrant/giconfig.conf
then
    cp /vagrant/gitconfig.conf ~root/.gitconfig	
fi

git config --global advice.detachedHead false

git config --global core.hooksPath /vagrant/files/git-hooks/

mkdir -p /vagrant/git-log
