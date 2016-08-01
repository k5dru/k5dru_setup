# k5dru_setup

NO WARRANTY OR SUPPORT.

Personal setup scripts for Centos 7 / Fedora 22 type operating systems, created to be fast, simple, understandable, modifiable, flexible and repeatable. The goal is to automate, and thereby document, all setup functions from the base install to a functional desktop or application server.

THESE ALMOST CERTAINLY DON'T DO WHAT YOU WANT IN THEIR CURRENT STATE.
USE AT YOUR OWN RISK UNLESS YOU ARE ME. 

Current professional systems admins should have a better way of doing this. You can use these scripts as examples, or as-is if they fit your use case, with absolutely no warranty or support expressed or implied.

NO WARRANTY OR SUPPORT.

Quickstart: 
install Centos 7 and run:
```
yum -y update
yum -y install git 
git clone https://github.com/k5dru/k5dru_setup/
cd k5dru_setup/centos72
vi config.sh 
```
Then start running the config scripts you want in order. 

If you run the script again, the previously completed steps will not be run unless you edit the script.sh.log file and remove that entry, or modify the do_step comand with the --again $something modifier. 





