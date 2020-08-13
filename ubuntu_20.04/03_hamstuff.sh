#!/bin/bash -
# The K5DRU Config Script for new Ubuntu 20.04 installations

####  CONFIG SECTION ####
. config.sh 
#export GLOBAL_PRETEND=Y

#### EXECUTION BEGINS #### 

do_step usermod  -a -G dialout $ADMIN_USER
do_step usermod  -a -G audio $ADMIN_USER
# need to log out and back in for group changes to take effect; I choose to just reboot here 
do_step --logfirst shutdown -r now

#  utils for HF digital modes
do_step ${APT} install fldigi flrig wsjtx freedv gqrx-sdr qsstv
do_step ${APT} install trustedqsl

