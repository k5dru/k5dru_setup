#!/bin/bash -
# The K5DRU Config Script for new Ubuntu 20.04 installations

####  CONFIG SECTION ####
. config.sh 
#export GLOBAL_PRETEND=Y

#### EXECUTION BEGINS #### 


# from https://getcomposer.org/download/
do_step php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
do_step php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
do_step php composer-setup.php
do_step php -r "unlink('composer-setup.php');"

do_step mv composer.phar /usr/local/bin/composer


