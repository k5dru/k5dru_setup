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

#### LOCAL CONFIG 
echo -n enter desired postgres user database password :
read PGPASSWORD  
echo -n enter desired $ADMIN_USER database password :
read ADMINPASSWORD
PGVERSION=9.4

#### EXECUTION BEGINS #### 

# install and config postgresql 9.4 
# from : http://yum.postgresql.org/repopackages.php
# via http://www.unixmen.com/postgresql-9-4-released-install-centos-7/
# also here is a good resource: https://fedoraproject.org/wiki/PostgreSQL
do_step rpm -Uvh http://yum.postgresql.org/9.4/redhat/rhel-6-x86_64/pgdg-centos94-9.4-2.noarch.rpm
do_step --again 1 ${YUM} update

# do_step ${YUM} remove postgresql-server
do_step ${YUM} install postgresql94-server postgresql94-contrib postgresql94
do_step /usr/pgsql-9.4/bin/postgresql94-setup initdb
do_step patch /var/lib/pgsql/9.4/data/pg_hba.conf <<!
--- /var/lib/pgsql/9.4/data/pg_hba.conf.bak	2016-01-05 15:43:25.658453838 -0600
+++ /var/lib/pgsql/9.4/data/pg_hba.conf	2016-01-05 15:44:22.102748188 -0600
@@ -79,9 +79,10 @@
 # "local" is for Unix domain socket connections only
 local   all             all                                     peer
 # IPv4 local connections:
-host    all             all             127.0.0.1/32            ident
+host    all             all             127.0.0.1/32            md5
+host    $ADMIN_USER             $ADMIN_USER             192.168.1.0/24          md5
 # IPv6 local connections:
-host    all             all             ::1/128                 ident
+host    all             all             ::1/128                 md5
 # Allow replication connections from localhost, by a user with the
 # replication privilege.
 #local   replication     postgres                                peer
!
do_step systemctl enable postgresql-9.4 
do_step systemctl start postgresql-9.4
# do_step systemctl restart postgresql-9.4

# configure some database users, etc. 
do_step su - postgres -c "createuser $ADMIN_USER"  
do_step su - postgres -c "createdb $ADMIN_USER"  
do_step su - postgres -c psql <<!
alter user postgres with encrypted password '$PGPASSWORD';
create extension adminpack;
alter user $ADMIN_USER with encrypted password '$ADMINPASSWORD';
grant all privileges on database $ADMIN_USER to $ADMIN_USER;
!

# do this ONLY if you REALLY want REMOTE connections to the DB MACHINE!
do_step firewall-cmd --permanent --add-port=5432/tcp
do_step --again 1 firewall-cmd --reload
do_step sed -i.bak "s/#port = 5432/port = 5432/" /var/lib/pgsql/9.4/data/postgresql.conf
do_step sed -i.bak "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /var/lib/pgsql/9.4/data/postgresql.conf
do_step systemctl restart postgresql-9.4
# end of remote port hole poking

