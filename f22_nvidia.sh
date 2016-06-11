#!/bin/bash -
# The K5DRU Config Script for new Fedora 22 LXDE installations

####  CONFIG SECTION ####
ADMIN_USER=lemley   # your username. 
HOSTNAME=dadputer   # this hostrname.
YUM="dnf -y"        # how to run yum.
DELAY=1             # how long to delay before an action, hit control-c to break
GLOBAL_PRETEND=Y    # will do everything but actually run the step 
# do_step --again 1  # will do a step again the first time; bump the number for
#                    #   multiple agains. 
# do_step --logfirst # will log the step as done, then do it. needed for reboot.
# do_step --pretend # will pretend to do only this step
. common.sh  # bring in definition of do_step

# EXTRA CONFIG FOR NVIDIA SCRIPT
# go here and find the driver version you want:  http://www.nvidia.com/object/unix.html
DRIVER_VERSION=352.41  # for newer cards
DRIVER_VERSION=340.96  # for older cards
DRIVER_FILE=NVIDIA-Linux-x86_64-$DRIVER_VERSION.run 
DOWNLOADS=/home/$ADMIN_USER/Downloads/

# from here: http://forums.fedoraforum.org/showthread.php?t=304646
# Fedora 22 Workstation and NVidia Linux Driver install (GTX 980 card in my case)(Allows full resolution and quiets down the NVidia fans in Linux)
##================================================== ===========================================
# Info:
#Fedora 22 version installed:	Fedora-Live-Workstation-x86_64-22-3.iso
#
#NVidia Linux x86_64 driver installed:	Current (2015-0619) driver used: NVIDIA-Linux-x86_64-352.21.run
#Download the NVidia "Linux x86_64/AMD64/EM64T" driver listed above here: http://www.nvidia.com/object/unix.html
 
if [ ! -e ${DOWNLOADS}/${DRIVER_FILE} ]; then 
	do_step curl http://us.download.nvidia.com/XFree86/Linux-x86_64/${DRIVER_VERSION}/${DRIVER_FILE} -o ${DOWNLOADS}${DRIVER_FILE}
fi

if [ ! -e ${DOWNLOADS}${DRIVER_FILE} ]; then 
	echo "not exist ${DOWNLOADS}${DRIVER_FILE}"
	exit 
fi

#
#Install the pre-requisites:
#---------------------------
do_step dnf -y install dkms gcc kernel-devel kernel-headers

#
#Blacklist and remove the default nouveau graphics driver:
#---------------------------------------------------------
do_step bash -c "cat >> /etc/modprobe.d/disable-nouveau.conf"  <<!
blacklist nouveau
nouveau modeset=0
!

#add "rd.driver.blacklist=nouveau" to middle of "GRUB_CMDLINE_LINUX=" line in /etc/sysconfig/grub
#Example:
#GRUB_CMDLINE_LINUX="rd.lvm.lv=fedora/swap rd.lvm.lv=fedora/root rd.driver.blacklist=nouveau rhgb quiet"
do_step sed -iOLD 's/rhgb/rd.driver.blacklist=nouveau rhgb/' /etc/sysconfig/grub
# the above didn't work.  trying /etc/default/grub:
do_step sed -iOLD 's/rhgb/rd.driver.blacklist=nouveau rhgb/' /etc/default/grub
do_step rm /etc/sysconfig/grubOLD
do_step rm /etc/default/grubOLD

#Activate blacklist change:
#--------------------------
do_step grub2-mkconfig -o /boot/grub2/grub.cfg

#Remove default nouveau driver:
#------------------------------
do_step dnf -y remove xorg-x11-drv-nouveau

#
#Set computer to boot to run level 3 (non-graphical boot) and reboot:
#--------------------------------------------------------------------
do_step systemctl set-default multi-user.target

# reboot if not in text mode 
if [ "$(systemctl get-default)" == "multi-user.target" ]; then 
	echo "good; already in text mode"
else
	echo "rebooting to be in text mode"
	do_step --logfirst --again 1 shutdown -r now
fi

#
#Install the NVidia driver:
#----------------------------
do_step chmod +x ${DOWNLOADS}${DRIVER_FILE}
do_step sh  ${DOWNLOADS}${DRIVER_FILE}

#accept license
#allow dkms module updates with new kernel updates
#install 32bit compatibility
#allow it to update your xorg.cfg file
#
#If successful, then:
#--------------------
#Set computer to boot to run level 5 (graphical boot) and reboot:
#----------------------------------------------------------------
do_step systemctl set-default graphical.target
do_step --logfirst --again 2 shutdown -r now
