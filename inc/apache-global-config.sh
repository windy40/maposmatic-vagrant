#! /bin/bash

sed -ie 's/EXPORT LANG=C/EXPORT LANG=C.UTF-8/' /etc/apache2/envvars
