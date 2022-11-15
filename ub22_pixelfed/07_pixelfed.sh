#!/bin/bash -
# The K5DRU Config Script for new Ubuntu 20.04 installations

####  CONFIG SECTION ####
. config.sh 
#export GLOBAL_PRETEND=Y

PIXELFED_DB_PW="Change#This.Example#9385219"

#### EXECUTION BEGINS #### 

do_step mv /var/www/html /var/www/html.orig
do_step mkdir /var/www/html
do_step chown www-data.www-data /var/www/html

cd /var/www/html
do_step git clone -b dev https://github.com/pixelfed/pixelfed.git .

# Fix permissions
do_step chown -R www-data:www-data .
do_step find . -type d -exec chmod 755 {} \;
do_step find . -type f -exec chmod 644 {} \;

do_step composer install --no-ansi --no-interaction --optimize-autoloader

do_step cp .env.example .env
do_step sed -i 's/localhost/'$HOSTNAME.$DOMAIN'/' .env
do_step sed -i 's/DB_PASSWORD="pixelfed"/DB_PASSWORD="'$PIXELFED_DB_PW'"/' .env

# Generate the secret APP_KEY
do_step php artisan key:generate

# Link the storage directory to the app
do_step php artisan storage:link

# Perform database migrations
do_step php artisan migrate --force

# Import cities
do_step php artisan import:cities

# Cache routes and view
do_step php artisan route:cache
do_step php artisan view:cache

# Cache configuration
do_step php artisan config:cache

# Set up job queueing using Horizon
do_step php artisan horizon:install
do_step php artisan horizon:publish
