#!/bin/bash -
# The K5DRU Config Script for new Fedora 22 LXDE installations

####  CONFIG SECTION ####
. config.sh 

#### EXECUTION BEGINS #### 

do_step ${YUM} install firewalld 
do_step ${YUM} install openssh-server
do_step firewall-cmd --permanent --add-source=64.250.38.207 --zone=trusted
do_step firewall-cmd --permanent --add-service=ssh --zone trusted
do_step firewall-cmd --permanent --remove-service=ssh --zone=public
do_step firewall-cmd --reload
