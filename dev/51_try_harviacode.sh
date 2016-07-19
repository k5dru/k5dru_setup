
# note -- this never worked for me.   The server presents an error that I don't know how to debug. 
# probably though - this wasn't designed for postgresql.


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
ENCRYPTION_KEY=$(dd if=/dev/urandom bs=1 count=512 | tr -dc 'a-zA-Z0-9_.' | cut -b 1-64)

do_step rm -rf harviacode /var/www/${SITE}/.htaccess /var/www/${SITE}/assets /var/www/${SITE}/harviacode

exit 

do_step git clone https://bitbucket.org/harviacode/codeigniter-crud-generator/src harviacode
cd harviacode
do_step chown -R apache: harviacode/ .htaccess assets/
do_step mv harviacode/ assets/ .htaccess /var/www/${SITE}/
do_step sed -i.bak "s!\(\['base_url'\] =\) .*!\1 'https://m2d2.aa976.com/${SITE}';!" /var/www/${SITE}/application/config/config.php 
do_step sed -i.bak "s!\(\['index_page'\] =\) .*!\1 '';!" /var/www/${SITE}/application/config/config.php 
do_step sed -i.bak "s!\(\['url_suffix'\] =\) .*!\1 '.html';!" /var/www/${SITE}/application/config/config.php 
do_step sed -i.bak "s!\(\['encryption_key'\] =\) .*!\1 '$ENCRYPTION_KEY';!" /var/www/${SITE}/application/config/config.php 


do_step sed -i.bak "s!\(^.autoload\['libraries'\] =\) .*!\1 array('database', 'session');!" /var/www/${SITE}/application/config/autoload.php 
do_step sed -i.bak "s!\(^.autoload\['helper'\] =\) .*!\1 array('url');!" /var/www/${SITE}/application/config/autoload.php 
