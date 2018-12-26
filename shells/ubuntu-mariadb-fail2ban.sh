git clone https://fail2ban/fail2ban.git
cd fail2ban
sudo apt install python -y
sudo python setup.py install 


sudo cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.local
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# make changes to .local, not to .conf b/c .conf gets read first, but .local overrides any settings 

vi /etc/fail2ban/fail2ban.local 
