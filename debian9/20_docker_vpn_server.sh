#!/bin/bash -
# The K5DRU Config Script for new Fedora 22 LXDE installations

# NOTE:  even though this appears to work, I can't make it go. 
# therefore, disable this lest some person try to use it as-is: 
exit

####  CONFIG SECTION ####
. config.sh 

#### EXECUTION BEGINS #### 
#  basically I am following the steps here, on the smallest linode running debian 9. 
#  https://github.com/hwdsl2/docker-ipsec-vpn-server

do_step docker pull hwdsl2/ipsec-vpn-server

# Note:  this does not work on Linode unless running distro kernel. 
# see  https://www.linode.com/docs/tools-reference/custom-kernels-distros/run-a-distribution-supplied-kernel-with-kvm
# for easy fix.
do_step modprobe af_key

do_step firewall-cmd --permanent --add-port=500/udp
do_step firewall-cmd --permanent --add-port=4500/udp
do_step firewall-cmd --permanent --add-port=500/udp --zone=trusted
do_step firewall-cmd --permanent --add-port=4500/udp --zone=trusted

do_step docker run \
--name ipsec-vpn-server \
--restart=always \
-p 500:500/udp \
-p 4500:4500/udp \
-v /lib/modules:/lib/modules:ro \
-d --privileged \
hwdsl2/ipsec-vpn-server

# --env-file /home/$ADMIN_USER/vpn-gen.env \
do_step docker cp ipsec-vpn-server:/opt/src/vpn-gen.env /home/$ADMIN_USER/vpn-gen.env
do_step chown $ADMIN_USER /home/$ADMIN_USER/vpn-gen.env


