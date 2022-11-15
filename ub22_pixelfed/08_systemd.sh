#!/bin/bash -
# The K5DRU Config Script for new Ubuntu 20.04 installations

####  CONFIG SECTION ####
. config.sh 
#export GLOBAL_PRETEND=Y

#### EXECUTION BEGINS #### 

cat > /etc/systemd/system/pixelfed.service <<!
[Unit]
Description=Pixelfed task queueing via Laravel Horizon
After=network.target
Requires=mysql
Requires=php-fpm
Requires=redis
Requires=nginx

[Service]
Type=simple
#ExecStart=/usr/bin/php /usr/share/webapps/pixelfed/artisan horizon
ExecStart=/usr/bin/php /var/www/html/artisan horizon
#User=http
Restart=on-failure

[Install]
WantedBy=multi-user.target
!

do_step systemctl enable --now pixelfed
do_step systemctl restart pixelfed.service

