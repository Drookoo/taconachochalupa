#!/bin/bash
#./superbuntu-internal.sh

#Change passwords 
sudo passwd ubuntu
sudo passwd root 

#add own superuser 
sudo adduser drew 
sudo adduser drew sudo

#remove the premade superuser from sudo 
sudo deluser ubuntu sudo

#Change time 
sudo dpkg-reconfigure tzdata 

#Disallow root logins over SSH
sudo echo "PermitRootLogin no" >> vi /etc/ssh/sshd_config
sudo echo "PasswordAuthentication no" >> vi /etc/ssh/sshd_config

#

#install! 
sudo apt-get install nmap debsecan -y 


#find ssh_keys 
#Find something to do with them
sudo find / |grep "\.pem"

#Debsecan scans all packages if they are exploitable, lists them all 
sudo debsecan --suite=sid 



####################################################
#				Install and start Nessus  			#
####################################################
#TODO: update the nessus reg code and make sure the directory makes sense 
cd ..
cd installs 
sudo dpkg -i Nessus-ubuntu.deb
sudo /etc/init.d/nessusd start 
sudo /opt/nessus/sbin/nessuscli fetch --register 7261-CF0A-6E86-1E8E-3064
sudo /opt/nessus/sbin/nessuscli update
sudo systemctl restart nessusd

 