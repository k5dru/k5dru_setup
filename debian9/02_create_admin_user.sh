#!/bin/bash -
# The K5DRU Config Script for new Fedora 22 LXDE installations

####  CONFIG SECTION ####
. config.sh 

#### EXECUTION BEGINS #### 

do_step adduser  $ADMIN_USER 
do_step adduser  $ADMIN_USER sudo


