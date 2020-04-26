#! /bin/bash

cd /vagrant/test
chmod a+w .
rm -f test-* thumbnails/test-*
./run-tests.sh

php /vagrant/files/tools/all-styles-pdf.php > all-styles.tex
pdflatex all-styles.tex > /dev/null

