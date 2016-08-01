#!/bin/bash -
# The K5DRU Config Script for new Fedora 22 LXDE installations

# TODO:  make encrypted mount point owned by more than just postgresql, so I can put 
#  this site on encrypted storage. 

####  CONFIG SECTION ####
. config.sh 

# LOCAL CONFIG 
SITE=m2d2
SITEROOT=/var/www  
DB_USERNAME=${SITE}_admin

echo removing $SITE directory 
do_step --again 1$SITE rm -rf $SITEROOT/$SITE 

echo removing $SITE apache file
do_step --again 1$SITE rm /etc/httpd/conf.d/${SITE}.conf
do_step --again 1$SITE systemctl restart httpd.service

echo dropping database
do_step su - postgres -c "dropdb $SITE"  

echo dropping user 
do_step --again 1$SITE su - postgres -c psql <<!
drop user $DB_USERNAME; 
!

echo done
