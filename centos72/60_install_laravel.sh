#!/bin/bash -
# The K5DRU Config Script for new Fedora 22 LXDE installations

# TODO:  make encrypted mount point owned by more than just postgresql, so I can put 
#  this site on encrypted storage. 

####  CONFIG SECTION ####
. config.sh 

# LOCAL CONFIG 

# from https://www.rosehosting.com/blog/install-laravel-on-centos-7/

### Make sure your server is fully up to date:
do_step yum update
### Before proceeding, let’s install Apache, MariaDB and PHP 5.6 along with it’s needed dependencies. First, install the EPEL and Webtatic repositories with the below commands:

# yum install epel-release
# rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
## You can now install LAMP (Linux Apache, MariaDB & PHP):
do_step yum install php56w-mcrypt php56w-dom php56w-mbstring unzip 

### Skip this since I'm already using postgresql: 
## Start MariaDB and Apache, then enable them to start on boot:
# systemctl start mariadb
# systemctl start httpd
# systemctl enable mariadb
# systemctl enable httpd

##Next, install Composer which is the tool for dependency management in PHP.
do_step bash -c "curl -k -sS https://getcomposer.org/installer | php"

##Once Composer is installed, you need to move it so that Composer can be available within your machine path.
## To check your available path locations type the following:
# echo $PATH
##The output will provide you with the path locations. Put composer in the /usr/local/bin/ directory:

do_step mv composer.phar /usr/local/bin/composer
##Navigate into a directory where you will download Laravel. We are using /opt :

# jump to instructions on laravel.com:
do_step composer global require laravel/installer

