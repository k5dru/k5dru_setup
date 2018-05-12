#!/bin/bash -
# The K5DRU Config Script for new Fedora 22 LXDE installations

####  CONFIG SECTION ####
. config.sh

#### EXECUTION BEGINS #### 

sudo docker ps -a 
sudo docker container restart silly_pasteur # portainer
sudo docker container restart  wordpressdb
sudo docker container restart wpcontainer
sudo docker container restart  adoring_lichterman # openvpn
sudo docker ps -a 

echo now try this in a browser: http://aidan.farted.net:9000/#/dashboard
