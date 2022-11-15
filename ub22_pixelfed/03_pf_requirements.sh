#!/bin/bash -
# The K5DRU Config Script for new Ubuntu 20.04 installations

####  CONFIG SECTION ####
. config.sh 
#export GLOBAL_PRETEND=Y

#### EXECUTION BEGINS #### 


do_step ${APT} install nginx mysql-server php php-gd php-bcmath php-ctype php-curl php-exif php-iconv php-intl php-json php-mbstring php-redis php-tokenizer php-xml php-zip php-mysql php-fpm ffmpeg redis git libgl-dev gcc libc6-dev libjpeg-dev make optipng pngquant

echo my hostname is $HOSTNAME.$DOMAIN

do_step sed -i 's/server_name _/server_name '$HOSTNAME.$DOMAIN'/' /etc/nginx/sites-available/default

do_step ${APT} install certbot python3-certbot-nginx
do_step certbot --nginx -d $HOSTNAME.$DOMAIN


do_step mysql_secure_installation
# workaround for this step not working: https://stackoverflow.com/questions/72103302/mysql-installation-on-ubuntu-20-04-error-when-using-mysql-secure-installation

