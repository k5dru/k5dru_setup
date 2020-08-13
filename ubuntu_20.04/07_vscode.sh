#!/bin/bash -
# The K5DRU Config Script for new Ubuntu 20.04 installations

####  CONFIG SECTION ####
. config.sh 
#export GLOBAL_PRETEND=Y

#### EXECUTION BEGINS #### 

# from https://code.visualstudio.com/docs/setup/linux

do_step bash -c 'curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg'
do_step install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
do_step rm packages.microsoft.gpg
do_step bash -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
do_step apt-get install apt-transport-https
do_step apt-get update
do_step apt-get install code # or code-insiders

