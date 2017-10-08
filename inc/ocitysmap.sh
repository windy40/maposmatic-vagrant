#----------------------------------------------------
#
# Fetch OCitysMap from GitHub and configure it
#
#----------------------------------------------------

# install latest ocitysmap from git
cd /home/maposmatic
git clone -q https://github.com/hholzgra/ocitysmap.git
cd ocitysmap
git checkout PoiMarker-python3
./i18n.py --compile-mo
cd ..

