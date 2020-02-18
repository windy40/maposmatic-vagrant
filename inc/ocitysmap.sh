#----------------------------------------------------
#
# Fetch OCitysMap from GitHub and configure it
#
#----------------------------------------------------

# install latest ocitysmap from git
cd /home/maposmatic
git clone --quiet https://github.com/hholzgra/ocitysmap.git
cd ocitysmap
git submodule init
git submodule update
./i18n.py --compile-mo
chmod a+x render.py
cp /vagrant/files/config-files/ocitysmap-command.sh /usr/local/bin/ocitysmap
chmod a+x /usr/local/bin/ocitysmap
cd ..

