#!/bin/bash -
# The K5DRU Config Script for new Fedora 22 LXDE installations

####  CONFIG SECTION ####
. config.sh 
#export GLOBAL_PRETEND=Y

#### EXECUTION BEGINS #### 

do_step hostnamectl set-hostname $HOSTNAME
do_step bash -c 'echo "127.0.0.1 $(hostname)" >> /etc/hosts'
do_step ${YUM} install firewalld 
do_step ${YUM} install openssh-server
do_step firewall-cmd --permanent --add-source=64.250.38.207 --zone=trusted
do_step firewall-cmd --permanent --add-service=ssh --zone trusted
do_step firewall-cmd --permanent --remove-service=ssh --zone=public
do_step firewall-cmd --reload
do_step firewall-cmd --permanent --add-source=64.250.0.0/16 --zone=trusted
do_step --again 1 firewall-cmd --reload
