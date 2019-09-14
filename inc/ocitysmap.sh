#----------------------------------------------------
#
# Fetch OCitysMap from GitHub and configure it
#
#----------------------------------------------------

# install latest ocitysmap from git
cd /home/maposmatic
git clone --quiet https://github.com/hholzgra/ocitysmap.git
cd ocitysmap
./i18n.py --compile-mo
cd ..

