#!/bin/bash -
# The K5DRU Config Script for new Ubuntu 20.04 installations

####  CONFIG SECTION ####
. config.sh 
#export GLOBAL_PRETEND=Y

#### EXECUTION BEGINS #### 

do_step wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /home/$ADMIN_USER/Downloads/google-chrome-stable_current_amd64.deb 
do_step dpkg -i /home/$ADMIN_USER/Downloads/google-chrome-stable_current_amd64.deb
# undo these things that command did:  
# update-alternatives: using /usr/bin/google-chrome-stable to provide /usr/bin/x-www-browser (x-www-browser) in auto mode
# update-alternatives: using /usr/bin/google-chrome-stable to provide /usr/bin/gnome-www-browser (gnome-www-browser) in auto mode
do_step update-alternatives --set x-www-browser /usr/bin/firefox
do_step update-alternatives --set gnome-www-browser /usr/bin/firefox
# remove the installation package
do_step rm /home/$ADMIN_USER/Downloads/google-chrome-stable_current_amd64.deb
