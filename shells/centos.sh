#!/bin/bash


#list upgradeable patches 
yum check-update

#list past upgrades, saves to file 

#hardening

#Increase the delay time between login prompts (10sec)
sed -i "s/delay=[[:digit:]]\+/delay=10000000/" /etc/pam.d/login 

#prevent root-owned files from accidentally becoming accessible to non priviledged users 
usermod -g 0 root 

