#!/bin/bash -
# The K5DRU Config Script for new Ubuntu 20.04 installations

####  CONFIG SECTION ####
. config.sh 
#export GLOBAL_PRETEND=Y

#### EXECUTION BEGINS #### 

do_step ${APT} install virtualbox-qt virtualbox-dkms linux-headers-generic
# need to reboot before virtualbox will see the dkms 
do_step --logfirst shutdown -r now


