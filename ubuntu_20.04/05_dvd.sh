#!/bin/bash -
# The K5DRU Config Script for new Ubuntu 20.04 installations

####  CONFIG SECTION ####
. config.sh 
#export GLOBAL_PRETEND=Y

#### EXECUTION BEGINS #### 

# This machine has a DVD player.  would be nice to be able to play old DVDs.  
# Warning: this might not be strictly legal in some freedom-hating countries, or so I've read.
do_step add-apt-repository universe
do_step add-apt-repository multiverse
do_step apt update
do_step ${APT} install libdvdnav4 libdvdread7 gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly libdvd-pkg
do_step dpkg-reconfigure libdvd-pkg
do_step ${APT} install vlc

