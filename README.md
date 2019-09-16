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

* A working Vagrant (>= v2.2) / Virtualbox (>= v5.2) setup

* A minimum of 4GB available RAM, 3GB for the VM, and 1GB extra head room for the host system

* About 30GB of disk space minimum (the more the larger your OSM PBF extract import file is)

* A working internet connection 

* Sufficient bandwidth, about 4GB of data will be downloaded during installation and provisioning 

## Installation and useage

* Copy a OSM PBF extract of your choice into this directory. If multiple files with ending '.pbf' are found only the first one is used. 
* Run "vagrant up"
* Be patient ...
 * The stylesheets require quite some extra downloads, and some processing on these (shape files, height information, ...). The downloads are cached localy, so downloads only happens on the first start mostly
 * Importing the provided OSM PBF file can take some time, too, depending on its size ...
* When the VM starts to test the different style sheets and overlays it is actually already ready to use.
 * You can access the web interface on http://localhost:8000/
 * Or you can log into the VM with "vagrant ssh", e.g. to run the command line renderer directly or to do actual development work

## File system layout

### On the host 

<dl>
  <dt>Vagrantfile</dt>
  <dd>Main virtual machine setup file</dd>
  
  <dt>provision.sh</dt>
  <dd>Top level provisioning script, executes all scripts found in the inc/ folder</dd>
  
  <dt>cache/</dt>
  <dd>Used for cacheing downloads</dd>
  
  <dt>files/</dt>
  <dd>Contains extra files needed by the provisioning scripts</dd>
  
  <dt>inc/</dt>
  <dd>Contains all the provisioning shell scripts</dd>
  
  <dt>inc/styles/</dt>
  <dd>Provisioning scripts and ocitysmap ini file snippets for map styles</dd>
  
  <dt>inc/overlays/</dt>
  <dd>Provisioning scripts and ocitysmap ini file snippets for map overlays</dd>
  
  <dt>test</dt>
  <dd>Shared folder for running render tests in the VM and have results visible on the host</dd>
</dl>

### In the VM

Inside the VM almost everything gets installed under the `/home/maposmatic` directory.

<dl>
  <dt>elevation-data</dt>
  <dd>Ditigal elevation model data for hillshadings and reliefs</dd>
  
  <dt>ocitysmap</dt>
  <dd>The MapOSMatic OCitysMap renderer</dd>
  
  <dt>maposmatic</dt>
  <dd>The MapOSMatic web frontend</dd>

  <dt>osmosis-diffimport</dt>
  <dd>Data dir for OSM diff imports to update the databasse</dd>
  
  <dt>shapefiles</dt>
  <dd>All shapefiles required by the different map styles installed</dd>

  <dt>styles</dt>
  <dd>All installed mapstyles are here, with the exception of the maposmatic-printable style which is part of the ocitysmap renderer repository</dd>

  <dt>tools</dt>
  <dd>All tools that need to be installed from source</dd>

  <dt>umgebungsplaene</dt>
  <dd>The neighbourhood maps project, an alternative frontend to the MapOSMatic rendering service</dd>
</dl>

## Database updates

If the OSM PBF file you used for the initial data import provides
a replication base URL to fetch diffs from, a systemd service 
will be set up to download such diff files and to apply the changes
to the database.

E.g. GeoFabrik provides daily diff files for all their regional extracts,
so if you downloaded the PBF file used for initial setup from there
your database can be brought up to date with

  systemctl start osm2pgsql-update

If no `replication_base_url` information is found in the initial import
file, then the service will not be installed at all. (This unfortunately
is also true for full planet files at this point, but I don't expect
anyone to try a full planet import inside a VM anyway. If you actually
*do* plan to do this, please let me (<hartmut@php.net>) know and I'll
see what I can work out to support automatic diff import setup for this,
too)
