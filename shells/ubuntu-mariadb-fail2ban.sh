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
