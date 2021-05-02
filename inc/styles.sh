#! /bin/bash

INCDIR=${INCDIR:-/vagrant/inc}

#----------------------------------------------------
#
# Set up various stylesheets 
#
#----------------------------------------------------

mkdir -p /home/maposmatic/styles

cd $INCDIR

# process all base styles
for style in ./styles/*.sh
do
  banner $(basename $style .sh)" style"
  ( . $style )
done

# process all overlay styles
for overlay in ./overlays/*.sh
do
  banner $(basename $overlay .sh)" overlay"
  ( . $overlay )
done

#----------------------------------------------------
#
# Postprocess all generated style sheets
#
#----------------------------------------------------

banner "postprocessing styles"

. ocitysmap-conf.sh

