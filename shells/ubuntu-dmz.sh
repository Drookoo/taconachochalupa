#list # of patches available
sudo apt update 

# list name of patches available 
sudo apt list --upgradeable 

#list past upgrades, saves to file
grep " installed " /var/log/dpkg.log > installed.txt

#list ALL local users, no jargon 
cut -d: -f1 /etc/passwd

#list ALL normal (non-system, non-weird) users 
awk -F'[/:]' '{if ($3 >= 1000 && $3 != 65534) print $1}' /etc/passwd

#list system + weird users
awk -F'[/:]' '{if ($3 <= 999) print $1}' /etc/passwd

#Delete the user and all files owned by the user on the whole system 
#sudo deluser --remove-all-files ccdc

#check who is currently loggedin 
w 

#check login history
lastlog 


