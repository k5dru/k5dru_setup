#!/bin/bash -
# The K5DRU Config Script for new Fedora 22 LXDE installations

####  CONFIG SECTION ####
. config.sh

#### EXECUTION BEGINS #### 

# need additional repositories: 
# epel, for phpPgAdmin, and webtatic. 
# webtatic, for PHP 5.6.
# do_step rpm -Uvh http://mirror.pnl.gov/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
do_step ${YUM} install epel-release
do_step rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
do_step --again 3 ${YUM} update

# install PHP 
# do_step ${YUM} install php-gd php-pgsql php-mbstring php-xml 
do_step ${YUM} install php56w php56w-opcache 

do_step cp /etc/php.ini /etc/php.ini.bak
do_step patch /etc/php.ini <<!
--- /etc/php.ini.bak	2016-01-05 15:36:01.094011659 -0600
+++ /etc/php.ini	2016-01-05 15:36:36.178573041 -0600
@@ -402,7 +402,7 @@
 
 ; Maximum amount of memory a script may consume (128MB)
 ; http://php.net/memory-limit
-memory_limit = 128M
+memory_limit = 512M
 
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ; Error handling and logging ;
!

do_step chcon -R -t httpd_sys_content_rw_t /var/www/html
do_step setsebool -P httpd_can_network_connect_db on

# install and configure phpPgAdmin
do_step ${YUM} install phpPgAdmin

do_step sed -i.bak "s/.'host'. = ''/['host'] = 'localhost'/" /etc/phpPgAdmin/config.inc.php

do_step patch /etc/httpd/conf.d/phpPgAdmin.conf <<!
--- /etc/httpd/conf.d/phpPgAdmin.conf.bak	2016-01-05 16:32:59.633274037 -0600
+++ /etc/httpd/conf.d/phpPgAdmin.conf	2016-01-05 16:41:17.738046870 -0600
@@ -8,7 +8,7 @@
 <Location /phpPgAdmin>
     <IfModule mod_authz_core.c>
         # Apache 2.4
-        Require local
+        Require all granted
         #Require host example.com
     </IfModule>
     <IfModule !mod_authz_core.c>
@@ -16,6 +16,7 @@
         Order deny,allow
         Deny from all
         Allow from 127.0.0.1
+        Allow from 192.168.1.0/24
         Allow from ::1
         # Allow from .example.com
     </IfModule>
!
do_step systemctl restart httpd.service

echo done.  Try going to http://hugeserver/phpPgAdmin/ in your browser. 
