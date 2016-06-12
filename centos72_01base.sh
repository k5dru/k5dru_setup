#!/bin/bash -
# The K5DRU Config Script for new Fedora 22 LXDE installations

####  CONFIG SECTION ####
ADMIN_USER=lemley   # your username. 
HOSTNAME=hugeserver   # this hostname.
YUM="yum -y"        # how to run yum.
DELAY=1             # how long to delay before an action, hit control-c to break
GLOBAL_PRETEND=Y    # will do everything but actually run the step 
# do_step --again 1  # will do a step again the first time; bump the number for
#                    #   multiple agains. 
# do_step --logfirst # will log the step as done, then do it. needed for reboot.
# do_step --pretend # will pretend to do only this step
. common.sh  # bring in definition of do_step

#### EXECUTION BEGINS #### 

# fixup sudoers for no password operation by admins 
do_step sed -iOLD 's/\(^#.\)\(%wheel.*NOPASSWD.*\)/\2/' /etc/sudoers
do_step sed -iOLD "s/localhost.localdomain/$HOSTNAME/" /etc/hostname

# enable delta RPMs, and update installation
do_step ${YUM} install drpmsync
do_step ${YUM} update

# install fest 
do_step ${YUM} install wget curl xauth xterm git readline-devel bzip2-libs bzip2-devel mlocate net-tools
do_step ${YUM} groups mark convert
do_step ${YUM} groupinstall "Development Tools"

# enable to login from remote
do_step ${YUM} install openssh-server  
do_step systemctl enable sshd.service
do_step systemctl start sshd.service

# install development tools 
do_step ${YUM} install gcc kernel-headers kernel-devel lzop pigz

# add me to groups 
do_step usermod  -a -G wheel $ADMIN_USER
do_step usermod  -a -G dialout $ADMIN_USER
do_step usermod  -a -G lock $ADMIN_USER

# install, configure and start Apache web server 
do_step ${YUM} install httpd httpd-manual mod_fcgid mod_ssl mod_wsgi

do_step firewall-cmd --permanent --add-port=80/tcp
do_step firewall-cmd --permanent --add-port=443/tcp
do_step firewall-cmd --reload

do_step systemctl enable httpd.service
do_step systemctl start httpd.service
do_step cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.bak
do_step patch /etc/httpd/conf/httpd.conf <<!
--- httpd.conf.bak	2016-01-05 15:07:43.810230626 -0600
+++ httpd.conf	2016-01-05 15:09:45.308711686 -0600
@@ -129,31 +129,11 @@
 
 # Further relax access to the default document root:
 <Directory "/var/www/html">
-    #
-    # Possible values for the Options directive are "None", "All",
-    # or any combination of:
-    #   Indexes Includes FollowSymLinks SymLinksifOwnerMatch ExecCGI MultiViews
-    #
-    # Note that "MultiViews" must be named *explicitly* --- "Options All"
-    # doesn't give it to you.
-    #
-    # The Options directive is both complicated and important.  Please see
-    # http://httpd.apache.org/docs/2.4/mod/core.html#options
-    # for more information.
-    #
-    Options Indexes FollowSymLinks
-
-    #
-    # AllowOverride controls what directives may be placed in .htaccess files.
-    # It can be "All", "None", or any combination of the keywords:
-    #   Options FileInfo AuthConfig Limit
-    #
-    AllowOverride None
-
-    #
-    # Controls who can get stuff from this server.
-    #
-    Require all granted
+    # from http://tripal.info/node/150
+      Options Indexes FollowSymLinks MultiViews
+      AllowOverride All
+      Order allow,deny
+      allow from all
 </Directory>
 
 #
!

# allow lemley@dadputer to login without a password
# JUST STOP HERE 
exit 

# ONLY DO THIS IF YOU ARE ME. 
do_step su - root -c "ssh-keygen"
do_step su - $ADMIN_USER -c "ssh-keygen"
do_step scp lemley@dadputer:.ssh/id_rsa.pub /root/.ssh/authorized_keys
do_step chmod 700 /root/.ssh/authorized_keys
do_step cp /root/.ssh/authorized_keys /home/$ADMIN_USER/.ssh/authorized_keys
do_step chown $ADMIN_USER /home/$ADMIN_USER/.ssh/authorized_keys
do_step chmod 700 /home/$ADMIN_USER/.ssh/authorized_keys


