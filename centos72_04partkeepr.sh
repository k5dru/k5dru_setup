#!/bin/bash -
# The K5DRU Config Script for new Fedora 22 LXDE installations

####  CONFIG SECTION ####
ADMIN_USER=lemley   # your username. 
HOSTNAME=hugeserver   # this hostname.
YUM="yum -y"        # how to run yum.
DELAY=0.2             # how long to delay before an action, hit control-c to break
GLOBAL_PRETEND=N    # will do everything but actually run the step 
# do_step --again 1  # will do a step again the first time; bump the number for
#                    #   multiple agains. 
# do_step --logfirst # will log the step as done, then do it. needed for reboot.
# do_step --pretend # will pretend to do only this step
. common.sh  # bring in definition of do_step

# LOCAL CONFIG 

PARTKEEPR_VERSION=1.0.0
echo enter a password to use for the PostgreSQL role "partkeepr"
read PARTKEEPR_PASSWORD

#### EXECUTION BEGINS #### 

# install pear 
do_step ${YUM} install php56w-pear php56w-pecl-imagick php56w-gd php56w-ldaa php56w-intl php56w-pecl-apcu

do_step pear channel-discover pear.symfony.com
do_step pear channel-discover pear.doctrine-project.org
do_step pear channel-discover pear.twig-project.org
do_step pear install pear.doctrine-project.org/DoctrineORM
do_step pear install doctrine/DoctrineSymfonyYaml
do_step pear install pear.doctrine-project.org/DoctrineSymfonyConsole
do_step pear install twig/Twig

#install partkeepr 
do_step mkdir -p /home/$ADMIN_USER/Downloads
do_step chown $ADMIN_USER /home/$ADMIN_USER/Downloads

if [ ! -e /home/$ADMIN_USER/Downloads/partkeepr-${PARTKEEPR_VERSION}.zip ]; then 
do_step	wget http://partkeepr.org/downloads/partkeepr-${PARTKEEPR_VERSION}.zip \
	-O /home/$ADMIN_USER/Downloads/partkeepr-${PARTKEEPR_VERSION}.zip 
fi
do_step unzip -d /var/www/ /home/$ADMIN_USER/Downloads/partkeepr-${PARTKEEPR_VERSION}.zip
do_step rm -rf /var/www/inventory-old
do_step mv /var/www/html/inventory /var/www/html/inventory-old
do_step mv /var/www/partkeepr-${PARTKEEPR_VERSION} /var/www/html/inventory 
do_step chown -R apache.apache /var/www/html/inventory
do_step chmod -R 755 /var/www/html/inventory

# create some DB users
do_step su - postgres -c "createuser partkeepr"  
# do_step su - postgres -c "createdb partkeepr"  
do_step su - postgres -c psql <<!
drop database partkeepr;
create database partkeepr;
alter user partkeepr with encrypted password '$PARTKEEPR_PASSWORD';
grant all privileges on database partkeepr to partkeepr;
!

# turn off selinux -- this file, doesn't do anything: 
do_step sed -i.bak "s/^SELINUX=.*/SELINUX=permissive/" /etc/sysconfig/selinux 
# this one does: 
do_step sed -i.bak "s/^SELINUX=.*/SELINUX=permissive/" /etc/selinux/config
do_step setenforce 0 
sestatus
do_step sed -i.bak "s!;date.timezone =!date.timezone = America/Chicago!" /etc/php.ini

echo Going to reboot to enable selinux permissive mode.
echo .  When it is back, point your browser at http://hugeserver/inventory/web/setup/
echo and cat /var/www/html/inventory/app/authkey.php 

do_step systemctl restart httpd.service
do_step --logfirst shutdown -r now

# TODO:  partkeepr says for me to set up a cron job, but it doesn't work as my user; who's crontab?
#  Please remember to setup a cronjob:
#   0 0,6,12,18 * * * /usr/bin/php <path-to-partkeepr>/app/console partkeepr:cron:run
#  The cronjob should run at least every 12 hours. Remove any legacy PartKeepr cronjobs.
# If possible, set your web server's document root to the web/ directory.
