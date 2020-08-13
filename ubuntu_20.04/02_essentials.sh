#!/bin/bash -
# The K5DRU Config Script for new Ubuntu 20.04 installations

####  CONFIG SECTION ####
. config.sh 
#export GLOBAL_PRETEND=Y

#### EXECUTION BEGINS #### 

#  change default sudoers password timeout from 5 minutes to 8 hours. 
do_step sed -i 's/^Defaults.*env_reset$/&,timestamp_timeout=480/' /etc/sudoers

do_step ${APT} update

# essential development
do_step ${APT} install vim nmon gparted git gitk rsync build-essential pavucontrol dislocker
do_step ${APT} install lzop pigz pv
do_step ${APT} install netcat traceroute curl python-is-python3 python3-virtualenv
do_step ${APT} install net-tools smartmontools
do_step ${APT} install mlocate 
do_step updatedb
do_step su - $ADMIN_USER -c "ssh-keygen"

# set vim to be the default editor 
do_step update-alternatives --install /usr/bin/editor editor /usr/bin/vim 100

# add local bin to my path.  I shouldn't have to do this. 
do_step su - $ADMIN_USER -c "mkdir -p bin"
do_step su - $ADMIN_USER -c "echo 'PATH=${PATH}:~/bin; export PATH' >> .bashrc"
