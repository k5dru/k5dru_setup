#!/bin/bash -
# The K5DRU Config Script for installing a Minecraft server on Centos 7 

####  CONFIG SECTION ####
. config.sh 

# LOCAL CONFIG 
MINECRAFT_VERSION=1.10.2

### Make sure your server is fully up to date:
do_step yum update

# install java for minecraft 
# install screen for persistent sessions 
# install psmisc for "killall" command 

do_step yum -y install java-1.8.0-openjdk screen  psmisc

# put .jar file in /usr/local/minecraft 

do_step mkdir -p /usr/local/minecraft
cd /usr/local/minecraft
do_step wget https://s3.amazonaws.com/Minecraft.Download/versions/${MINECRAFT_VERSION}/minecraft_server.${MINECRAFT_VERSION}.jar -O minecraft_server.jar
do_step chmod +x minecraft_server.jar

#commands to start your Minecraft Server
# MINECRAFT_CMD="java -Xmx1024M -Xms1024M -jar /usr/local/minecraft/minecraft_server.jar nogui"
MINECRAFT_CMD="java -Xmx768M -Xms768M -jar /usr/local/minecraft/minecraft_server.jar nogui"

do_step --again 1 bash -c "cat > /usr/local/minecraft/start_minecraft.sh" <<!
echo trying to start Minecraft server at $(date) >> minecraft.log 
echo $MINECRAFT_CMD >> minecraft.log 
nohup $MINECRAFT_CMD >> minecraft.log 2>&1 & 
tail -fn100 minecraft.log
!

do_step chmod +x /usr/local/minecraft/start_minecraft.sh

# allow external connections through software firewall:	
do_step firewall-cmd --permanent --add-port=25565/tcp
do_step firewall-cmd --reload

