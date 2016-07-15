#!/bin/bash -
# The K5DRU Config Script for new Fedora 22 LXDE installations

####  CONFIG SECTION ####
. config.sh 

#### EXECUTION BEGINS #### 

# enable delta RPMs, and update installation
do_step ${YUM} install epel-release 
do_step ${YUM} install certbot

echo 'choose the "webroot" plugin'
do_step certbot certonly --webroot -w /var/www/html -d $DOMAIN 
do_step certbot renew --dry-run

echo 'consider renewing automatically per https://certbot.eff.org/#centosrhel7-apache'

#   Server Private Key:
#   If the key is not combined with the certificate, use this
#   directive to point at the key file.  Keep in mind that if
#   you've both a RSA and a DSA private key you can configure
#   both in parallel (to also allow the use of DSA ciphers, etc.)

# point to new certs, and also disable SSLv3

do_step sed -iOLD 's!\(SSLCertificateFile \).*!\1/etc/letsencrypt/live/'$DOMAIN'/cert.pem!;
s!\(SSLCertificateKeyFile \).*!\1/etc/letsencrypt/live/'$DOMAIN'/privkey.pem!;
s!.*\(SSLCertificateChainFile \).*!\1/etc/letsencrypt/live/'$DOMAIN'/chain.pem!;
s!SSLProtocol all -SSLv2.*!SSLProtocol all -SSLv2 -SSLv3!;
' /etc/httpd/conf.d/ssl.conf

do_step bash -c 'cat >> /etc/httpd/conf.d/ssl.conf' <<!
NameVirtualHost *:80
<VirtualHost *:80>
   ServerName $DOMAIN
   Redirect permanent / https://$DOMAIN/
</VirtualHost>
!

do_step --again 3 systemctl restart httpd.service

