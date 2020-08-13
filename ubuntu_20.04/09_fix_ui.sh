#!/bin/bash -
# The K5DRU Config Script for new Ubuntu 20.04 installations

####  CONFIG SECTION ####
. config.sh 
#export GLOBAL_PRETEND=Y

#### EXECUTION BEGINS #### 

## this moves the apps icon to the top of the dock.  Then you can set the doc to be at the bottom of the screen
## and the apps icon is now in the right spot.
#do_step bash -c 'echo show-apps-at-top=true >> /usr/share/glib-2.0/schemas/10_ubuntu-dock.gschema.override'
#do_step glib-compile-schemas /usr/share/glib-2.0/schemas/

# this is even better: 
do_step ${APT} install chrome-gnome-shell gnome-shell-extension-prefs gnome-shell-extension-dash-to-panel

# then display a message
do_step bash -c 'echo "after reboot point your browser to https://extensions.gnome.org/ and enable dash-to-panel" && sleep 10'

# then reboot
do_step --logfirst shutdown -r now

