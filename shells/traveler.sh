#!/bin/bash
#./traveler.sh

#Change passwords 
sudo passwd ubuntu
sudo passwd root 
sudo passwd galadriel 

#add own superuser 
sudo adduser drew 
sudo adduser drew sudo

#delete the premade superuser 
sudo deluser ubuntu sudo

#Change time 
sudo dpkg-reconfigure tzdata 

#install! 
sudo apt-get install nmap debsecan -y 

#find ssh_keys 
#Find something to do with them
sudo find / |grep "\.pem"

#Debsecan scans all packages if they are exploitable, lists them all 
sudo debsecan --suite=sid 