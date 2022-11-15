#!/bin/bash -
# The K5DRU Config Script for new Ubuntu 20.04 installations

####  CONFIG SECTION ####
. config.sh 
#export GLOBAL_PRETEND=Y

#### EXECUTION BEGINS #### 


do_step git clone https://github.com/tjko/jpegoptim.git
cd jpegoptim
do_step ./configure
do_step make
do_step make strip
do_step sudo make install
cd ..
do_step rm -r jpegoptim
