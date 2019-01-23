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

#
chown root:root /etc/ssh/sshd_config
chmod og-rwx /etc/ssh/sshd_config

chown root:root /etc/passwd
chmod 644 /etc/passwd

chown root:shadow /etc/shadow
chmod o-rwx,g-wx /etc/shadow

chown root:root /etc/group
chmod 644 /etc/group

chown root:shadow /etc/gshadow
chmod o-rwx,g-rw /etc/gshadow

chown root:root /etc/passwd-
chmod 600 /etc/passwd-

chown root:root /etc/shadow-
chmod 600 /etc/shadow-

chown root:root /etc/group-
chmod 600 /etc/group-

chown root:root /etc/gshadow-
chmod 600 /etc/gshadow-