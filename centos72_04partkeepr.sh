#!/bin/bash -
# The K5DRU Config Script for new Fedora 22 LXDE installations

####  CONFIG SECTION ####
ADMIN_USER=lemley   # your username. 
HOSTNAME=hugeserver   # this hostname.
YUM="yum -y"        # how to run yum.
DELAY=1             # how long to delay before an action, hit control-c to break
GLOBAL_PRETEND=N    # will do everything but actually run the step 
# do_step --again 1  # will do a step again the first time; bump the number for
#                    #   multiple agains. 
# do_step --logfirst # will log the step as done, then do it. needed for reboot.
# do_step --pretend # will pretend to do only this step
. common.sh  # bring in definition of do_step

# LOCAL CONFIG 

PARTKEEPR_VERSION=1.0.0
#### EXECUTION BEGINS #### 

# install pear 
do_step ${YUM} install php56w-pear php56w-pecl-imagick php56w-gd php56w-ldap
do_step pear channel-discover pear.symfony.com
do_step pear channel-discover pear.doctrine-project.org
do_step pear channel-discover pear.twig-project.org
do_step pear install pear.doctrine-project.org/DoctrineORM
do_step pear install doctrine/DoctrineSymfonyYaml
do_step pear install pear.doctrine-project.org/DoctrineSymfonyConsole
do_step pear install twig/Twig

#install partkeepr 
if [ ! -e partkeepr-${PARTKEEPR_VERSION}.zip ]; then 
	wget http://partkeepr.org/downloads/partkeepr-${PARTKEEPR_VERSION}.zip
fi
do_step unzip -d /var/www/ partkeepr-${PARTKEEPR_VERSION}.zip
do_step rm -rf /var/www/inventory-old
do_step mv /var/www/html/inventory /var/www/html/inventory-old
do_step mv /var/www/partkeepr-${PARTKEEPR_VERSION} /var/www/html/inventory 
do_step chown -R apache.apache /var/www/html/inventory
do_step chmod -R 755 /var/www/html/inventory

# turn off selinux -- this file, doesn't do anything: 
do_step sed -i.bak "s/^SELINUX=.*/SELINUX=permissive/" /etc/sysconfig/selinux 
# this one does: 
do_step sed -i.bak "s/^SELINUX=.*/SELINUX=permissive/" /etc/selinux/config
do_step setenforce 0 
sestatus
do_step sed -i.bak "s!;date.timezone =!date.timezone = America/Chicago!" /etc/php.ini
do_step --logfirst shutdown -r now


