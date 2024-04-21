#! /bin/bash

deactivate
. $INSTALLDIR/bin/activate

cd $VAGRANT/test
chmod a+w .
rm -f test-* thumbnails/test-*
./run-tests.sh

php $FILEDIR/tools/all-styles-pdf.php > all-styles.tex
pdflatex all-styles.tex > /dev/null

