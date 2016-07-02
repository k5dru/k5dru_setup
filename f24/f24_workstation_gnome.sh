#!/bin/bash -
# The K5DRU Config Script for new Fedora 22 LXDE installations

####  CONFIG SECTION ####
ADMIN_USER=lemley   # your username. 
HOSTNAME=lappyshop   # this hostrname.
YUM="dnf -y"        # how to run yum.
DELAY=1             # how long to delay before an action, hit control-c to break
GLOBAL_PRETEND=N    # will do everything but actually run the step 
# do_step --again 1  # will do a step again the first time; bump the number for
#                    #   multiple agains. 
# do_step --logfirst # will log the step as done, then do it. needed for reboot.
# do_step --pretend # will pretend to do only this step
. ../common.sh  # bring in definition of do_step

#### EXECUTION BEGINS #### 

# fixup sudoers for no password operation by admins 
do_step sed -iOLD 's/\(^#.\)\(%wheel.*NOPASSWD.*\)/\2/' /etc/sudoers
do_step usermod -a -G wheel $ADMIN_USER
 
# set my hostname
# done in install: do_step sed -iOLD "s/localhost.localdomain/$HOSTNAME/" /etc/hostname

# update everything 
do_step ${YUM} update

# reboot
do_step --logfirst --again 1 shutdown -r now  

# on my personal laptop, I do NOT want firewall. 
do_step ${YUM} remove firewalld 

# install SSH and the ability to log in from another computer. 
do_step ${YUM} install openssh-server  
do_step systemctl enable sshd.service
do_step systemctl start sshd.service

# install RPM Fusion repository
do_step ${YUM} install --nogpgcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Begin the installfest of things I like 
do_step ${YUM} install gstreamer rhythmbox gstreamer-plugins-good gstreamer-plugins-bad gstreamer-plugins-ugly 

# why i686 versions of these?  something required it but I don't remember what: 
# do_step ${YUM} install alsa-lib.i686 libXv.i686 libXScrnSaver.i686 qt.i686 qt-x11.i686  

#continue installfest
do_step ${YUM} install xine-lib xine-lib-extras-freeworld 
# missing; avidemux 

#Q: why was I tryhing to install uvcdynctrlx ?
#A: for a webcam.
do_step ${YUM} install uvcdynctrl audacious gnupg pygame audacity bzflag gimp xscreensaver-gl-extras

# for development I need a bunch of things
do_step ${YUM} install gcc kernel-headers kernel-devel  kernel-tools

# I sure do like LibreOffice.  Install it. 
do_step ${YUM} install libreoffice-calc libreoffice-writer libreoffice-impress libreoffice-draw lzop 

do_step ${YUM} install gparted  xsane gcc kernel-devel python-easygui pnmixer ImageMagick gnofract4d 
do_step ${YUM} install eog batti cheese  arduino gedit chirp transmission hplip cups cups-pdf hexchat
do_step ${YUM} install  system-config-printer hpijs hplip hplip-gui bristol frozen-bubble supertuxkart supertux 
do_step ${YUM} install  extremetuxracer rakarrack jack-audio-connection-kit qjackctl stellarium armacycles-ad 
do_step ${YUM} install  bzflag k3b libdvdread libdvdnav lsdvd dvgrab cabextract

if [ 'LXDE' = 'TRUE' ]; then 

# auto hide the LXDE panel 
do_step sed -iOLD 's/autohide=0/autohide=1/' /home/$ADMIN_USER/.config/lxpanel/LXDE/panels/panel
do_step rm /home/$ADMIN_USER/.config/lxpanel/LXDE/panels/panelOLD

# add battery monitor if not there 
grep 'type = batt' /home/$ADMIN_USER/.config/lxpanel/LXDE/panels/panel ||
do_step bash -c "cat >> /home/$ADMIN_USER/.config/lxpanel/LXDE/panels/panel"  <<!
Plugin {
    type = batt
    Config {
        HideIfNoBattery=0
        AlarmCommand=zenity --warning --text='Battery low'
        AlarmTime=5
        BackgroundColor=black
        BorderWidth=1
        ChargingColor1=#28f200
        ChargingColor2=#22cc00
        DischargingColor1=#ffee00
        DischargingColor2=#d9ca00
        Size=8
    }
}

!

fi 


# these only work after enabling RPMFUSION 
do_step ${YUM} install vlc audacious-plugins-freeworld-mp3 unrar stella gltron 
# mame is missing in F24 

# install google chrome
do_step bash -c "cat > /etc/yum.repos.d/google-chrome.repo"  <<!
[google-chrome]
name=google-chrome
baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl.google.com/linux/linux_signing_key.pub
!

do_step ${YUM} install google-chrome-stable

# these are all required for vmware player: 
# do_step ${YUM} install kernel-* make gcc gcc-c++ kernel-headers kernel-devel sudo m4 automake autoconf libtool intltool

#######
# these are required for verious ham radio projects: 
# build_gqrx.sh:  
do_step  ${YUM} install git gcc gcc-c++ gnuradio-devel qconf qt5-qtbase-devel qt5-qtsvg-devel tar make pulseaudio-libs-devel gnuradio-devel gnuradio boost-devel libusb-devel 

# fldigi_build_fedora.sh:
do_step ${YUM} install pulseaudio-libs-devel fltk-devel libsamplerate-devel

# wsjtx_fedora.sh:
do_step ${YUM} install portaudio portaudio-devel  qt5-qtbase qt5-qtbase-devel qconf gcc gcc-c++ gcc-gfortran libgcc libstdc++ numpy libgfortran subversion hamlib hamlib-c++ hamlib-c++-devel fftw-devel qt5-qtmultimedia-devel qt5-qtserialport-devel cmake

# libdvdcss, from rpmfind.net 
do_step ${YUM} install ftp://rpmfind.net/linux/sourceforge/p/po/postinstaller/fedora/releases/22/x86_64/libdvdcss-1.3.99-1.fc22.x86_64.rpm

# msttcorefonts from rpmfind.net
do_step ${YUM} install ftp://rpmfind.net/linux/sourceforge/p/po/postinstaller/fedora/releases/22/x86_64/msttcorefonts-2.5-1.fc22.noarch.rpm

# realcrypt? 
# was at ftp://fr2.rpmfind.net/linux/rpmfusion/nonfree/fedora/releases/20/Everything/x86_64/os/realcrypt-7.1a-2.fc20.x86_64.rpm
# now gone 
do_step ${YUM} install ftp://rpmfind.net/linux/rpmfusion/nonfree/fedora/releases/20/Everything/x86_64/os/realcrypt-7.1a-2.fc20.x86_64.rpm


if [ -e /opt/Adobe/Reader9/bin/acroread ]; then 
	do_step ln -s /opt/Adobe/Reader9/bin/acroread /usr/bin/acroread
fi

if [ 'MINECRAFT' = 'TRUE' ]; then 

# Download and create a launcher for Mincraft. 
if [ ! -e /home/$ADMIN_USER/Downloads/Minecraft.jar ]; then
do_step curl https://s3.amazonaws.com/Minecraft.Download/launcher/Minecraft.jar -o /home/$ADMIN_USER/Downloads/Minecraft.jar
fi
do_step chown $ADMIN_USER /home/$ADMIN_USER/Downloads/Minecraft.jar
do_step bash -c "cat > /home/$ADMIN_USER/Desktop/Minecraft.sh"  <<!
java -jar /home/$ADMIN_USER/Downloads/Minecraft.jar
!
do_step chown $ADMIN_USER /home/$ADMIN_USER/Desktop/Minecraft.sh
do_step chmod 755 /home/$ADMIN_USER/Desktop/Minecraft.sh
do_step curl http://images.wikia.com/yogbox/images/d/dd/Minecraft_Block.svg -o /usr/share/icons/Minecraft_Block.svg
do_step bash -c "cat >  /usr/share/applications/minecraft.desktop"  <<!
[Desktop Entry]
Categories=Game;ArcadeGame;
Name=Minecraft
GenericName=3D block game
Comment=3D block game addictive like crack
Exec=java -jar /home/$ADMIN_USER/Downloads/Minecraft.jar
Icon=/usr/share/icons/Minecraft_Block.svg
Terminal=false
Type=Application
StartupNotify=true
X-Desktop-File-Install-Version=0.22
!

fi 


do_step ${YUM} install wine
do_step curl http://dl.google.com/earth/client/advanced/current/GoogleEarthWin.exe -o /home/$ADMIN_USER/Downloads/GoogleEarthWin.exe
do_step chown $ADMIN_USER  /home/$ADMIN_USER/Downloads/GoogleEarthWin.exe
do_step su - $ADMIN_USER -c "wine /home/$ADMIN_USER/Downloads/GoogleEarthWin.exe"

# add me to all the groups 
do_step usermod  -a -G wheel $ADMIN_USER
do_step usermod  -a -G dialout $ADMIN_USER
do_step usermod  -a -G lock $ADMIN_USER
do_step usermod  -a -G audio $ADMIN_USER
do_step usermod  -a -G jackuser $ADMIN_USER

# install freedv from Hobbes repo
#do_step curl https://copr.fedoraproject.org/coprs/hobbes1069/FreeDV/repo/fedora-22/hobbes1069-FreeDV-fedora-22.repo -o /etc/yum.repos.d/hobbes1069-FreeDV-fedora-22.repo 
do_step ${YUM} install freedv pavucontrol 

exit

#                    NOTES AND OLD SCRIPT BELOW HERE 

# FIXME: suspend, from "fedora system suspend laptop lid"
#   I set in /etc/systemd/logind.conf HandleLidSwitch=hibernate
# NOTE:  resume from hibernation does not work.  It crashes.
# FIXME:  grub hibernation, from "Hibernate on Fedora 21 does not resume"
#  edit this: [lemley@lappy6410 radio]$ sudo vi /etc/default/grub 
#  add this:  GRUB_CMDLINE_LINUX="rhgb quiet resume=/dev/sda3"
# do this:     sudo grub2-mkconfig -o /boot/grub2/grub.cfg 
#  I don't remember what this was supposed to fix: 
# sudo ln -s /usr/src/kernels/$(uname -r)/include/generated/uapi/linux/version.h /usr/src/kernels/$(uname -r)/include/linux/version.h  
