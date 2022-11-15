#!/bin/bash -
# The K5DRU Config Script for new Ubuntu 20.04 installations

####  CONFIG SECTION ####
. config.sh 
#export GLOBAL_PRETEND=Y

#### EXECUTION BEGINS #### 

#  change default sudoers password timeout from 5 minutes to 8 hours. 
do_step sed -i 's/^Defaults.*env_reset$/&,timestamp_timeout=480/' /etc/sudoers

# update system
do_step ${APT} update
do_step ${APT} upgrade

# essential development
do_step ${APT} install vim nmon git gitk rsync plocate
do_step updatedb

# set vim to be the default editor 
do_step update-alternatives --install /usr/bin/editor editor /usr/bin/vim 100

# add local bin to my path.  I shouldn't have to do this. 
do_step su - $ADMIN_USER -c "mkdir -p bin"
do_step su - $ADMIN_USER -c "echo 'PATH=${PATH}:~/bin; export PATH' >> .bashrc"
