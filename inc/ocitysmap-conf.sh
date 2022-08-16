#! /bin/sh

CONF=/home/maposmatic/.ocitysmap.conf
INCDIR=${INCDIR:-/vagrant/inc}

cat <<EOF > $CONF
[datasource]
host=localhost
user=maposmatic
password=secret
dbname=gis

[paper_sizes]
Din A4= 210x297
Din A3= 297x420
Din A2= 420x594
Din A1= 594x841
Din A0= 841x1189
2x A0= 1189x1682
US letter= 216x279

[multipage_paper_sizes]
Din A4= 210x297
US letter= 216x279

[rendering]
font-path=/usr/share/fonts/:/usr/local/share/fonts/
EOF

echo -n "available_stylesheets= " >> $CONF
grep --no-filename '\[.*\]' $INCDIR/styles/*.ini | sed -e 's/\[//g' -e 's/\]//g' | paste -sd "," >> $CONF

echo -n "available_overlays= " >> $CONF
grep --no-filename '\[.*\]' $INCDIR/overlays/*.ini | sed -e 's/\[//g' -e 's/\]//g' | paste -sd "," >> $CONF

cat $INCDIR/styles/*.ini $INCDIR/overlays/*.ini >> $CONF

rm -f /root/.ocitysmap.conf
ln -s $CONF /root/.ocitysmap.conf

rm -f $VAGRANT/.ocitysmap.conf
ln -s $CONF $VAGRANT/.ocitysmap.conf


