# maposmatic-vagrant

Performs a full MapOsMatic installation in an Ubuntu 15.10 VM using Vagrant and shell provisioning

## Components

The following components will be installed into the VM:

* OCitysMap rendering backend (from my own modified fork)
* MapOSMatic web frontend (again from my own fork)
* Stylesheets:
 * Current OSM default style
 * MapOSMatic Printable style
 * HikeBikeMap style
 * Humanitarian style (HOT)
 * MapQuest European style
 * German openstreetmap.de style
* Overlay stylesheets:
 * Golf overlay
 * Fire Hydrant overlay

## Requirements

* A working Vagrant setup

* A minimum of 2GB available RAM for the VM and a working internet connection 

## Installation and useage

* copy a OSM PBF extract of your choice into this directory and rename it to +data.osm.pbf+

* run "vagrant up"

* be patient ...
 * first build can take quite a while as it needs to compile Mapnik from scratch, this step gets much faster as Ccache is used and its cache files are preserved outside the VM 
 * the stylesheets require quite some extra downloads, and some processing on these (shape files, height information, ...)
 * importing the provided OSM PBF file can take some time, too, depending on its size ...

* once the VM is fully started and provisioned you can use your 
  MapOsMatic instance on http://localhost:8000/



