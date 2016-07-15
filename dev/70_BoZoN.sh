#!/bin/bash -
# The K5DRU Config Script for new Fedora 22 LXDE installations

####  CONFIG SECTION ####
. config.sh 
#### EXECUTION BEGINS #### 

do_step ${YUM} install php56w-gd

do_step --again 4 systemctl restart httpd.service

cd /var/www/html

do_step git clone https://github.com/broncowdd/BoZoN.git bozon
do_step chown apache -R bozon/
do_step chcon -R -t httpd_sys_content_rw_t /var/www/html/bozon

# make a development directory for a custom front-end
do_step mkdir /var/www/html/dev
do_step chown apache /var/www/html/dev
do_step chcon -R -t httpd_sys_content_rw_t /var/www/html/dev
