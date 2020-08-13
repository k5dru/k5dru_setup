#!/bin/bash -
# The K5DRU Config Script for new Ubuntu 20.04 installations

####  CONFIG SECTION ####
. config.sh 
#export GLOBAL_PRETEND=Y

#### EXECUTION BEGINS #### 

do_step hostnamectl set-hostname $HOSTNAME
do_step bash -c 'echo "127.0.0.1 $(hostname)" >> /etc/hosts'
do_step ${APT} install openssh-server
do_step --logfirst shutdown -r now
