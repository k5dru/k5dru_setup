#!/bin/bash -
# The K5DRU Config Script for new Ubuntu 20.04 installations

####  CONFIG SECTION ####
. config.sh 
#export GLOBAL_PRETEND=Y

#### EXECUTION BEGINS #### 

# todo: get password dynamically 
PIXELFED_DB_PW="Change#This.Example#9385219"

do_step mysql -u root -p -e "create database pixelfed"
do_step mysql -u root -p -e "create user 'pixelfed'@'localhost' identified by '$PIXELFED_DB_PW'"
do_step mysql -u root -p -e "grant all privileges on pixelfed.* to 'pixelfed'@'localhost'"
do_step mysql -u root -p -e "flush privileges"

do_step sed -i 's/max_execution_time = 30/max_execution_time = 600/' /etc/php/8.1/fpm/php.ini



