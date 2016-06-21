#!/bin/bash -
# The K5DRU Config Script for new Fedora 22 LXDE installations

####  CONFIG SECTION ####
. config.sh 

#### EXECUTION BEGINS #### 

# enable delta RPMs, and update installation
do_step ${YUM} install cryptsetup device-mapper util-linux

do_step cryptsetup --verify-passphrase --cipher aes-cbc-essiv:sha256 --key-size 256 luksFormat /dev/sdc

do_step cryptsetup luksOpen /dev/sdc enc_sdc

do_step mkfs.ext4 /dev/mapper/enc_sdc

# not sure why do this, but from 
# https://www.linux-geex.com/centos-7-how-to-setup-your-encrypted-filesystem-in-less-than-15-minutes/
do_step bash -c "cat > /etc/cryptotab" <<!
enc_sdc /dev/sdc none noauto
!

do_step bash -c "cat >> /etc/fstab" <<!
/dev/mapper/enc_sdc /var/lib/pgsql ext4 noauto,defaults 1 2 
!

do_step mkdir -p /var/lib/pgsql
do_step mount /var/lib/pgsql
