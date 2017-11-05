#!/bin/bash -
# The K5DRU Config Script for new Fedora 22 LXDE installations

####  CONFIG SECTION ####
. config.sh 

#### EXECUTION BEGINS #### 

do_step apt-get update
do_step apt-get -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common
do_step bash -c 'curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | apt-key add -'
do_step apt-key fingerprint 0EBFCD88
do_step sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable"
do_step --again 1 apt-get update
#NOTE! the website https://docs.docker.com/engine/installation/linux/docker-ce/debian/#install-docker-ce-1
# says to always install a particular version, not the latest.  i am ignoring that advice here.
do_step apt-get -y install docker-ce

