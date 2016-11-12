#----------------------------------------------------
#
# Fetch OCitysMap from GitHub and configure it
#
#----------------------------------------------------

# install latest ocitysmap from git
cd /home/maposmatic
git clone -q https://github.com/hholzgra/ocitysmap.git
cd ocitysmap
git checkout mapnik3
./i18n.py --compile-mo
cd ..

# copy predefined ocitysmap config file to default locations
cp $FILEDIR/ocitysmap.conf /home/maposmatic/.ocitysmap.conf
cp $FILEDIR/ocitysmap.conf /root/.ocitysmap.conf

