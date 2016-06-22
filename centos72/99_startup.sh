# verify version you installed if it doesn's start right up
PGVERSION=9.5

cryptsetup luksOpen /dev/sdc enc_sdc
mount /var/lib/pgsql
systemctl start postgresql-${PGVERSION}
