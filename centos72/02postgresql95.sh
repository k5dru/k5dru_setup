#!/bin/bash -
# The K5DRU Config Script for new Fedora 22 LXDE installations

####  CONFIG SECTION ####
. config.sh

#### LOCAL CONFIG 
echo -n enter desired postgres user database password :
read PGPASSWORD  
echo -n enter desired $ADMIN_USER database password :
read ADMINPASSWORD
PGVERSION=9.5
PGSHORTVERSION=95
PGDG=http://yum.postgresql.org/${PGVERSION}/redhat/rhel-7-x86_64/pgdg-centos${PGSHORTVERSION}-${PGVERSION}-2.noarch.rpm

# NOTE: most of this, plus PostGIS installation, is well documented at
#  http://www.postgresonline.com/journal/archives/362-An-almost-idiots-guide-to-install-PostgreSQL-9.5,-PostGIS-2.2-and-pgRouting-2.1.0-with-Yum.html

#### EXECUTION BEGINS #### 

# install and config postgresql ${PGVERSION} 
# from : http://yum.postgresql.org/repopackages.php
# via http://www.unixmen.com/postgresql-${PGVERSION}-released-install-centos-7/
# also here is a good resource: https://fedoraproject.org/wiki/PostgreSQL
do_step rpm -Uvh $PGDG
do_step --again 1 ${YUM} update

# do_step ${YUM} remove postgresql-server
do_step ${YUM} install postgresql${PGSHORTVERSION}-server postgresql${PGSHORTVERSION}-contrib postgresql${PGSHORTVERSION}
do_step /usr/pgsql-${PGVERSION}/bin/postgresql${PGSHORTVERSION}-setup initdb

do_step bash -c "cat > /var/lib/pgsql/${PGVERSION}/data/pg_hba.conf"  <<!
# TYPE  DATABASE        USER            ADDRESS                 METHOD
# "local" is for Unix domain socket connections only
local   all             all                                     peer
# IPv4 local connections:
host    all             all             127.0.0.1/32            md5
host    lemley          lemley          192.168.1.0/24          md5
# IPv6 local connections:
host    all             all             ::1/128                 md5
# Allow replication connections from localhost, by a user with the
# replication privilege.
#local   replication     postgres                                peer
!

do_step systemctl enable postgresql-${PGVERSION} 
do_step systemctl start postgresql-${PGVERSION}
# do_step systemctl restart postgresql-${PGVERSION}

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
do_step sed -i.bak "s/#port = 5432/port = 5432/" /var/lib/pgsql/${PGVERSION}/data/postgresql.conf
do_step sed -i.bak "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /var/lib/pgsql/${PGVERSION}/data/postgresql.conf

do_step --again 2 systemctl restart postgresql-${PGVERSION}
# end of remote port hole poking

