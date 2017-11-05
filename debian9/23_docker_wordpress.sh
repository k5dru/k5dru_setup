#!/bin/bash -
# The K5DRU Config Script for new Fedora 22 LXDE installations

####  CONFIG SECTION ####
. config.sh

#do this:  https://www.howtoforge.com/tutorial/how-to-install-wordpress-with-docker-on-ubuntu/
echo -n "enter mysql root password : "
read pw

do_step docker pull mariadb
do_step docker images

do_step su $ADMIN_USER - -c "mkdir -p /home/$ADMIN_USER/wordpress/database"
do_step su $ADMIN_USER - -c "mkdir -p /home/$ADMIN_USER/wordpress/html"

do_step docker run -e MYSQL_ROOT_PASSWORD=${pw} -e MYSQL_USER=wpuser -e MYSQL_PASSWORD=wpuser@ -e MYSQL_DATABASE=wordpress_db -v /home/$ADMIN_USER/wordpress/database:/var/lib/mysql --name wordpressdb -d mariadb

docker ps

do_step docker pull wordpress:latest

do_step docker run -e WORDPRESS_DB_USER=wpuser -e WORDPRESS_DB_PASSWORD=wpuser@ -e WORDPRESS_DB_NAME=wordpress_db -p 8081:80 -v /home/$ADMIN_USER/wordpress/html:/var/www/html --link wordpressdb:mysql --name wpcontainer -d wordpress

do_step ${YUM} -y install nginx

do_step bash -c "cat > /etc/nginx/sites-available/wordpress" <<!
server {
  listen 80;
  server_name wordpress-docker.co www.wordpress-docker.co;

  location / {
  proxy_pass http://localhost:8081;
  proxy_set_header Host \$host;
  proxy_set_header X-Real-IP \$remote_addr;
  proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
  }
}
!

do_step ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/
do_step rm -f /etc/nginx/sites-available/default
do_step rm -f /etc/nginx/sites-enabled/default
do_step systemctl restart nginx


# manual restore of old wordpress site backup:
# save off the new html/wp-config.php
# on server: cp wordpress/html/wp_config.php ~/wp-config.php.bak
# import the old dataqbase from my home-pc backup: 
# on pc: gzip -dc aidanwordpress.mysqldump.20171103.gz  | ssh aidan.farted.net  "mysql -u wpuser -h 172.17.0.2 --password=wpuser@ --database=wordpress_db"
# restore all the old wordpress html from my home pc backup:
# on server: sudo chown -R lemley wordpress/html
# on pc: rsync -a -v -t --exclude='*mp4' --exclude='*ogv' ./ aidan.farted.net:wordpress/html/
# on server: cp ~/wp_config.php.bak wordpress/html/wp-config.php
# on server: sudo chown -R www-data wordpress/html


