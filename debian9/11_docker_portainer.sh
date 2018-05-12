#!/bin/bash -
# The K5DRU Config Script for new Fedora 22 LXDE installations

####  CONFIG SECTION ####
. config.sh

#### EXECUTION BEGINS #### 
#  basically I am following the steps here, on the smallest linode running debian 9. 
# https://portainer.readthedocs.io/en/latest/deployment.html


do_step firewall-cmd --permanent --add-port=9000/tcp --zone=trusted

do_step docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v /opt/portainer:/data portainer/portainer


echo now try this in a browser: http://aidan.farted.net:9000/#/dashboard

