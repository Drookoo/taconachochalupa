#!/bin/bash 
#TODO: put osquery install files into /installs/ for easy retrieval

git clone https://fail2ban/fail2ban.git
cd fail2ban
sudo apt install python -y
sudo python setup.py install 


sudo cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.local
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

#make sure you are in the fail2ban directory

sudo cp files/debian-initd /etc/init.d/fail2ban
sudo update-rc.d fail2ban defaults
service fail2ban start

# make changes to .local, not to .conf b/c .conf gets read first, but .local overrides any settings 

vi /etc/fail2ban/fail2ban.local 

#[sshd]
#port = ssh
#logpath = %(sshd_log)s
#backend = %(sshd_backend)s 
#enabled = true 

#Restart to apply any changes 
#sudo fail2ban-client restart 

#Verify 
#sudo fail2ban-client status 
#systemctl systemctl status fail2ban 



#########################################

# OSQuery

#########################################

#Install
wget https://pkg.osquery.io/deb/osquery_3.3.0_1.linux.amd64.deb
sudo dpkg -i osquery_3.3.0_1.linux.amd64.deb

systemctl start osquerd.service 

#To use osquery shell 
osqueryi 

#select pid, name, path from processes;

#List users, description, directory 
select username, description, directory, type from users; 
#https://osquery.io/schema/3.3.0#users

#Networking
select interface, address, broadcast, type, friendly_name from interface_addresses; 

#last login
select username, time, host from last;

#TODO: combine listening_ports with processes to get PID, name, and port
#modify this:
# $osqueryi
#SELECT DISTINCT
#process.name,
#listening.port,
#process.pid
#from processes as process 
#join listening_ports as listening 
#on process.pid = listening.pid;

