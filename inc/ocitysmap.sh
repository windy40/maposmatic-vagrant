#----------------------------------------------------
#
# Fetch OCitysMap from GitHub and configure it
#
#----------------------------------------------------

# install latest ocitysmap from git
cd /home/maposmatic
git clone -q https://github.com/hholzgra/ocitysmap.git

# copy predefined ocitysmap config file to default locations
cp $FILEDIR/ocitysmap.conf /home/maposmatic/.ocitysmap.conf
cp $FILEDIR/ocitysmap.conf /root/.ocitysmap.conf

