#!/bin/bash -
# The K5DRU Config Script for new Fedora 22 LXDE installations

####  CONFIG SECTION ####
. config.sh

#### EXECUTION BEGINS #### 
#  basically I am following the steps here, on the smallest linode running debian 9. 
#  https://github.com/kylemanna/docker-openvpn

export OVPN_DATA="ovpn-data-farted"
export FQDN="aidan.farted.net"
export CLIENTNAME=dadrouter

do_step firewall-cmd --permanent --add-port=1194/udp
do_step firewall-cmd --permanent --add-port=1194/udp --zone=trusted

do_step docker volume create --name $OVPN_DATA
do_step docker run -v $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig -u udp://$FQDN
do_step docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn ovpn_initpki
do_step docker run -v $OVPN_DATA:/etc/openvpn -d -p 1194:1194/udp --cap-add=NET_ADMIN kylemanna/openvpn
do_step docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn easyrsa build-client-full $CLIENTNAME nopass
do_step bash -c "docker run -v $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn_getclient $CLIENTNAME > $CLIENTNAME.ovpn"


