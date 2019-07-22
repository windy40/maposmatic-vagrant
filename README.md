# maposmatic-vagrant

Performs a full MapOsMatic installation in an Ubuntu "Bionic" 18.04LTS VM using Vagrant and shell provisioning

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
 * ... and more ...
* Overlay stylesheets:
 * Golf overlay
 * Fire Hydrant overlay
 * ... and more ...

## Requirements

* A working Vagrant / Virtualbox setup

* A minimum of 2GB available RAM for the VM and a working internet connection 

* About 30GB of disk space minimum (the more the larger your OSM PBF extract import file is)

* Sufficient bandwidth, about 3GB of data will be downloaded during installation and provisioning 

## Installation and useage

* Copy a OSM PBF extract of your choice into this directory. If multiple files with ending '.pbf' are found only the first one is used. 
* Run "vagrant up"
* Be patient ...
 * The stylesheets require quite some extra downloads, and some processing on these (shape files, height information, ...). The downloads are cached localy, so this only happens on the first start mostly.
 * Importing the provided OSM PBF file can take some time, too, depending on its size ...
* Once the VM is fully started and provisioned you can use your 
  MapOsMatic instance on http://localhost:8000/



