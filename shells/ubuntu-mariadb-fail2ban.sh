git clone https://fail2ban/fail2ban.git
cd fail2ban
sudo apt install python -y
sudo python setup.py install 

# check the conf 
vi /etc/fail2ban/fail2ban.conf 