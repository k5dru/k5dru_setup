#!/bin/bash -
# The K5DRU Config Script for new Ubuntu 20.04 installations

####  CONFIG SECTION ####
. config.sh 
#export GLOBAL_PRETEND=Y

#### EXECUTION BEGINS #### 


do_step sed -i 's!/var/www/html;!/var/www/html/public;!' /etc/nginx/sites-available/default
do_step sed -i 's!index.nginx-debian.html!index.php!' /etc/nginx/sites-available/default
do_step sed -i 's!try_files.*404!try_files $uri $uri/ /index.php?$query_string!' /etc/nginx/sites-available/default

do_step patch /etc/nginx/sites-available/default <<!
@@ -51,11 +51,11 @@
 
 	# pass PHP scripts to FastCGI server
 	#
-	#location ~ \.php$ {
-	#	include snippets/fastcgi-php.conf;
-	#
-	#	# With php-fpm (or other unix sockets):
-	#	fastcgi_pass unix:/run/php/php7.4-fpm.sock;
+	location ~ \.php$ {
+		include snippets/fastcgi-php.conf;
+	
+		# With php-fpm (or other unix sockets):
+		fastcgi_pass unix:/run/php/php8.1-fpm.sock;
 	#	# With php-cgi (or other tcp sockets):
 	#	fastcgi_pass 127.0.0.1:9000;
-	#}
+	}
!

do_step --again 2 systemctl restart nginx.service

