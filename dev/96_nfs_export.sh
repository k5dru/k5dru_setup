#!/bin/bash -
# NOTE:  this is only done on my devopment VM, to share /var/www with the host.

####  CONFIG SECTION ####
. config.sh 

# LOCAL CONFIG 

do_step firewall-cmd --permanent --zone=public --add-service=nfs
do_step firewall-cmd --reload

do_step yum -y install nfs-utils 
do_step systemctl enable nfs-server.service
do_step systemctl start nfs-server.service

do_step bash -c "cat > /etc/exports" <<!
/var/www           gateway(rw,sync,no_root_squash,no_subtree_check)
!

do_step exportfs -a


