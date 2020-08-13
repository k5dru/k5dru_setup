#!/bin/bash -
# The K5DRU Config Script for new Ubuntu 20.04 installations

####  CONFIG SECTION ####
. config.sh 
#export GLOBAL_PRETEND=Y

#### EXECUTION BEGINS #### 

do_step ${APT} install audacity  lame
do_step ${APT} install libreoffice

# some simple graphics packages
do_step ${APT} install  xsane gimp

# sqlite3 isn't installed? what kind of distro is this even? 
do_step ${APT} install sqlite3

# to control an old webcam: 
do_step ${APT} install uvcdynctrl hexchat

# some coding stuff 
do_step ${APT} install jupyter-core python3-pip 
do_step su - $ADMIN_USER -c "pip3 install notebook"


# for jupyter
do_step su - $ADMIN_USER -c "echo 'PATH=${PATH}:~/.local/bin; export PATH' >> .bashrc"
