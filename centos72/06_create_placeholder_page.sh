#!/bin/bash -
# The K5DRU Config Script for new Fedora 22 LXDE installations

####  CONFIG SECTION ####
. config.sh 

# LOCAL CONFIG 

#### EXECUTION BEGINS #### 

do_step mkdir -p /home/$ADMIN_USER/Downloads
do_step chown $ADMIN_USER /home/$ADMIN_USER/Downloads

if [ ! -e /home/$ADMIN_USER/Downloads/matrix-coming-soon-free-web-template.zip ]; then 
do_step	wget http://webthemez.com/downloads/free/matrix-coming-soon-free-web-template.zip -O /home/$ADMIN_USER/Downloads/matrix-coming-soon-free-web-template.zip
fi
do_step unzip -d /var/www/ /home/$ADMIN_USER/Downloads/matrix-coming-soon-free-web-template.zip
do_step rsync -a -v -t /var/www/matrix-coming-soon-free-web-template/ /var/www/html/
do_step rm -r /var/www/matrix-coming-soon-free-web-template

do_step wget https://lawschooltuitionbubble.files.wordpress.com/2011/03/2011-03-12-give-me-your-data.jpg -O /var/www/html/images/2011-03-12-give-me-your-data.jpg 


do_step chcon -R -t httpd_sys_content_rw_t /var/www/html

do_step patch /var/www/html/index.html <<!
--- /var/www/html/index.html	2014-11-10 01:41:40.000000000 +0000
+++ index.html	2016-06-21 17:12:22.311031530 +0000
@@ -13,7 +13,7 @@
 <title>HTML5 Responsive coming soon page - Matrix</title>
 <meta name="description" content="">
 <meta http-equiv="X-UA-Compatible" content="chrome=1">
-<link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=PT+Sans+Narrow:regular,bold"> 
+<link rel="stylesheet" type="text/css" href="https://fonts.googleapis.com/css?family=PT+Sans+Narrow:regular,bold"> 
 <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
 <link rel="stylesheet" type="text/css" href="css/styles.css">
 </head>
@@ -23,10 +23,11 @@
 <div id="Content" class="wrapper topSection">
 	<div id="Header">
 	<div class="wrapper">
-		<div class="logo"><h1><img src="images/logo1.png" />MATRIX</h1>	</div>
+		<div class="logo"><h1><img src="images/logo1.png" />M<sup>2</sup>D<sup>2</sup></h1>	</div>
 		</div>
 	</div>
-	<h2>We are coming soon!!!</h2> 	
+	<h2>Maintenance Manager Data Depot (version next!)</h2> 	
+<center><h4><a href="phpPgAdmin">&gt; admin console &lt;</a></h4></center>
 <div class="countdown styled"></div>
 </div>
 </section>
!
