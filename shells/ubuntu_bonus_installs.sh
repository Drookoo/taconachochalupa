#!/bin/bash 
#Installs Vulns.io 


#Install docker 
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
sudo apt install docker-ce 

# sudo systemctl status docker 

#Install vuls 
sudo docker pull vuls/go-cve-dictionary
sudo docker pull vuls/goval-dictionary
sudo docker pull vuls/gost

# https://vuls.io/docs/en/tutorial-local-scan.html
# google tutorial for docker vuls 





