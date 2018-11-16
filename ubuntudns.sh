#list upgradeable patches 
sudo apt-list --upgradeable 
#try sudo apt update and see

#list past upgrades, saves to file
grep " installed " /var/log/dpkg.log > installed.txt

#to check to see what can be updates 
#sudo apt update


