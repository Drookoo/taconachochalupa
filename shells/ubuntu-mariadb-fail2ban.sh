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


#Webmap-NMap Install
#Make sure docker is installed already on the machine 
sudo mkdir /temp/webmap
sudo docker run -d --name webmap -h webmap -p 8000:8000 -v /tmp/webmap:/opt/xml rev3rse/webmap 
#Generate token 
sudo docker exec -ti webmap /root/token
#Go to another machine on the internal network and go to the machine's ip address:port 


# Bloodhound Install 
# sudo apt-get install wget curl git 
# sudo wget -O - https://debian.neo4j.org/neotechnology.gpg.key | sudo apt-key add - 
# sudo echo 'deb https://debian.neo4j.org/repo stable/' | sudo tee /etc/apt/sources.list.d/neo4j.list 
# will take long time maybe 
# sudo add-apt-repository universe 
# sudo apt-get update
# sudo apt install openjdk-8-jre-headless neo4j -y 
# IF YOU LOCKED /ETC/ YOU MUST PUT A PASSWORD ON ROOT AND THEN SU INTO ROOT to perform the following echo() 
# su 
# sudo echo "dbms.active_database=graph.db" >> /etc/neo4j/neo4j.conf
# sudo echo "dbms.connector.http.listen_address=:::7474" >> /etc/neo4j/neo4j.conf
# sudo echo "dbms.connector.bolt.listen_address=:::7687" >> /etc/neo4j/neo4j.conf
# sudo echo "dbms.allow_format_migration=true" >> /etc/neo4j/neo4j.conf 
# leave su 
# exit 
# sudo git clone https://github.com/adaptivethreat/BloodHound.git
# cd BloodHound
# mkdir /var/lib/neo4j/data/databases/graph.db #should say already exists 
# sudo cp -R BloodHoundExampleDB.graphdb/* /var/lib/neo4j/data/databases/graph.db
# sudo neo4j start 

# curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash -
# sudo apt-get install gcc make g++ nodejs -y
# sudo npm install -g electron-packager
# inside the bloodhound folder 
# su
# sudo npm install 
# sudo npm audit fix 
# sudo npm run linuxbuild






