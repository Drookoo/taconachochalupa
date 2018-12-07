#!/bin/bash

#centos is poc 
#must do: sudo vi /etc/yum.conf 
#hit 'i', on new line, add 'http_caching=packages', then hit 'esc' then :wq then enter

#List upgradeable patches 
yum check-update

#check if there is update for service and patch it if there is one
#yum list mariadb
#yum install mariadb

#List available security upgrades 
yum list security

#install security upgrades
#yum install security 

#list past upgrades, saves to file 
rpm -qa

#list ALL local users, no jargon 
cut -d: -f1 /etc/passwd

#list normal, non-weird, users 

#list system, weird users

#list last login time 

#hardening

#Increase the delay time between login prompts (10sec)
sed -i "s/delay=[[:digit:]]\+/delay=10000000/" /etc/pam.d/login 

#prevent root-owned files from accidentally becoming accessible to non priviledged users 
usermod -g 0 root 

#file permissions 
# Set /etc/passwd ownership and access permissions.
chown root:root /etc/passwd
chmod 644 /etc/passwd

# Set /etc/shadow ownership and access permissions.
chown root:shadow /etc/shadow
chmod 640 /etc/shadow

# Set /etc/group ownership and access permissions.
chown root:root /etc/group
chmod 644 /etc/group

# Set /etc/gshadow ownership and access permissions.
chown root:shadow /etc/gshadow
chmod 640 /etc/group

# Set /etc/security/opasswd ownership and access permissions.
chown root:root /etc/security/opasswd
chmod 600 /etc/security/opasswd

# Set /etc/passwd- ownership and access permissions.
chown root:root /etc/passwd-
chmod 600 /etc/passwd-

# Set /etc/shadow- ownership and access permissions.
chown root:root /etc/shadow-
chmod 600 /etc/shadow-

# Set /etc/group- ownership and access permissions.
chown root:root /etc/group-
chmod 600 /etc/group-

# Set /etc/gshadow- ownership and access permissions.
chown root:root /etc/gshadow-
chmod 600 /etc/gshadow-

#banner restrictions 
chown root:root /etc/motd
chmod 644 /etc/motd
echo "Authorized uses only. All activity may be monitored and reported." > /etc/motd
  
chown root:root /etc/issue
chmod 644 /etc/issue
echo "Authorized uses only. All activity may be monitored and reported." > /etc/issue
  
chown root:root /etc/issue.net
chmod 644 /etc/issue.net
echo "Authorized uses only. All activity may be monitored and reported." > /etc/issue.net
