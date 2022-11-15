
# edit to add: I'm following this script, kind of: 
# https://ahmedmusaad.com/self-host-pixelfed/
# on a new Ubuntu 22.04 LTS virtual server on Linode.  

# I ran this as root before even the git clone as my user

apt -y update 
apt -y upgrade

# these low memory instances really need more swap
if [ ! -f /swapfile01 ]; then
  echo setting up more swap ... 
  dd if=/dev/zero of=/swapfile01 bs=1M count=2048
  chmod 600 /swapfile01
  mkswap /swapfile01
  grep /dev/sdb /etc/fstab | sed "s!/dev/sdb!/swapfile01!" >> /etc/fstab
  swapon -a 
  swapon -s
fi

adduser lemley
adduser lemley sudo 
mkdir /home/lemley/.ssh
cp ~/.ssh/authorized_keys /home/lemley/.ssh
chmod -R 700 /home/lemley/.ssh
chown -R lemley.lemley /home/lemley/.ssh

