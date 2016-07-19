#!/bin/bash -
# The K5DRU Config Script for new Fedora 22 LXDE installations

# TODO:  make encrypted mount point owned by more than just postgresql, so I can put 
#  this site on encrypted storage. 

####  CONFIG SECTION ####
. config.sh 

# LOCAL CONFIG 
SITE=fleets
SITEROOT=/var/www  
DB_USERNAME=${SITE}_admin
echo -n Enter password for database user $DB_USERNAME:
read DB_PASSWORD


# go fetch codeigniter 
(
  cd $SITEROOT || (echo cannot cd to $SITEROOT; exit 1)
  do_step rm -rf $SITE
  do_step mkdir $SITE 
  do_step git clone --single-branch --branch 3.0-stable https://github.com/bcit-ci/CodeIgniter $SITE
  do_step chown apache: -R $SITE
  do_step chcon -R -t httpd_sys_content_rw_t $SITE
)


if [ ! -e /etc/httpd/conf.d/${SITE}.conf ]; then 
# add this as an apache virtual host
# NOTE it is recommended to remove the app from the webserver 
# here : https://codeigniter.com/user_guide/installation/index.html
# so do that before production
#

# copied from config of phpPgAdmin:
  do_step bash -c "cat > /etc/httpd/conf.d/${SITE}.conf" <<!
Alias /$SITE $SITEROOT/$SITE
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

fi  # end if not exists /etc/httpd/conf.d/${SITE}.conf




# create a database, and grant all privs to our user.  
do_step su - postgres -c "dropdb $SITE"  
do_step su - postgres -c "createdb $SITE"  
do_step --again 3 su - postgres -c psql $SITE <<!
create user $DB_USERNAME with encrypted password '$DB_PASSWORD';
grant all privileges on database $SITE to $DB_USERNAME;
!
 
#  from http://stackoverflow.com/questions/29630851/connecting-postgresql-and-codeigniter
do_step bash -c "cat >> /var/www/$SITE/application/config/database.php" <<!
\$db['default']['hostname'] = 'pgsql:host=localhost;dbname=$SITE'; //set host
\$db['default']['username'] = '$DB_USERNAME'; //set username
\$db['default']['password'] = '$DB_PASSWORD'; //set password
\$db['default']['database'] = '$SITE'; //set databse
\$db['default']['dbdriver'] = 'pdo'; //set driver here
!


echo done. 
echo Actual site is in $SITEROOT/$SITE
echo Try going to http://$DOMAIN/$SITE/ in your browser. 
