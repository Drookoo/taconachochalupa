#!/bin/bash 

#Nessus installer for internal ubuntu machine, Script #2 


cd ..
cd installs 
sudo dpkg -i Nessus-ubuntu.deb
sudo /etc/init.d/nessusd start 
sudo /opt/nessus/sbin/nessuscli fetch --register 7261-CF0A-6E86-1E8E-3064
sudo /opt/nessus/sbin/nessuscli update
sudo systemctl restart nessusd 

