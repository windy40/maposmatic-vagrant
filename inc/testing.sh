#! /bin/bash

cd /vagrant/test
chmod a+w .
rm -f test-* thumbnails/test-*
./run-tests.sh

php /vagrant/files/tools/all-styles-pdf.php > all-styles.tex
pdflatex all-styles.tex

# pdfjam --suffix nup --quiet --nup 5x5 --papersize '{594mm,841mm}' --outfile all-styles-poster.pdf test-base-*-pdf.pdf test-overlay-*-pdf.pdf
