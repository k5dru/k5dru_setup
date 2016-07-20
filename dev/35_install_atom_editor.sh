#!/bin/bash -
# The K5DRU Config Script for new Fedora 22 LXDE installations

# TODO:  make encrypted mount point owned by more than just postgresql, so I can put 
#  this site on encrypted storage. 

####  CONFIG SECTION ####
. config.sh 

do_step wget https://github.com/atom/atom/releases/download/v1.8.0/atom.x86_64.rpm
do_step yum localinstall atom.x86_64.rpm
