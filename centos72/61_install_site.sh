#!/bin/bash -
# The K5DRU Config Script for new Fedora 22 LXDE installations

# TODO:  make encrypted mount point owned by more than just postgresql, so I can put 
#  this site on encrypted storage. 

####  CONFIG SECTION ####
. config.sh 

# LOCAL CONFIG 
SITE=cars
SITEROOT=/var/www  
DB_USERNAME=${SITE}_admin
echo -n Enter password for database user $DB_USERNAME:
read DB_PASSWORD

(
  cd $SITEROOT || (echo cannot cd to $SITEROOT; exit 1)

  do_step --again 1 ~/.config/composer/vendor/laravel/installer/laravel new $SITE
  do_step --again 1 chown apache: -R $SITE
  do_step --again 1 chcon -R -t httpd_sys_content_rw_t $SITE
)

do_step chmod -R u+w /$SITEROOT/$SITE/storage
do_step chmod -R u+w /$SITEROOT/$SITE/bootstrap/cache

# add this as an apache virtual host 
#
# This configuration file maps the phpPgAdmin directory into the URL space. 
# By default this application is only accessible from the local host.
#

# copied from config of phpPgAdmin:
do_step --again 1 bash -c "cat > /etc/httpd/conf.d/${SITE}.conf" <<!
Alias /$SITE $SITEROOT/$SITE/public
<Location /$SITE>
    <IfModule mod_authz_core.c>
        # Apache 2.4
        Require all granted
        #Require host example.com
    </IfModule>
    <IfModule !mod_authz_core.c>
        # Apache 2.2
        Order deny,allow
        Deny from all
        Allow from 127.0.0.1
        Allow from 192.168.1.0/24
        Allow from ::1
        # Allow from .example.com
    </IfModule>
</Location>
!

systemctl restart httpd.service

echo done. 
echo Actual site is in $SITEROOT/$SITE
echo Try going to http://$DOMAIN/$SITE/ in your browser. 

# edits to laravel configs: 
do_step sed -i.bak "s!'timezone' => 'UTC'!'timezone' => 'America/Chicago'!" $SITEROOT/$SITE/config/app.php
do_step sed -i.bak "s!env('DB_CONNECTION', 'mysql')!env('DB_CONNECTION', 'pgsql')!" $SITEROOT/$SITE/config/database.php

do_step sed -i.bak "s!DB_CONNECTION=mysql!DB_CONNECTION=pgsql!;" $SITEROOT/$SITE/.env
do_step sed -i.bak "s!DB_PORT=3306!DB_PORT=5432!;" $SITEROOT/$SITE/.env
do_step sed -i.bak "s!DB_DATABASE=homestead!DB_DATABASE=$SITE!;" $SITEROOT/$SITE/.env
do_step sed -i.bak "s!DB_USERNAME=homestead!DB_USERNAME=$DB_USERNAME!;" $SITEROOT/$SITE/.env
do_step sed -i.bak "s!DB_PASSWORD=secret!DB_PASSWORD=$DB_PASSWORD!;" $SITEROOT/$SITE/.env

# create a database, and grant all privs to our manually-created user.  
# TODO:  automatically create this user. 
do_step su - postgres -c "dropdb $SITE"  
do_step su - postgres -c "createdb $SITE"  
do_step --again 3 su - postgres -c psql $SITE <<!
create user $DB_USERNAME with encrypted password '$DB_PASSWORD';
grant all privileges on database $SITE to $DB_USERNAME;
!

(
cd $SITEROOT/$SITE 
do_step --again 1 php artisan migrate
)

