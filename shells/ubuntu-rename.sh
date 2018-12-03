#ubuntu-splunk machine


#sudo git clone https://github.com/drookoo/taconachochalupa.git
#cd taconachochalupa
#sudo chmod +x ./ubuntu-server.sh

#just in case?
sudo apt install nmap 
sudo apt install xsltproc 

sudo nmap -v -A -T4 172.16.5.0/24 -oX ../internal.xml && sudo xsltproc ../internal.xml -o ../internal.html

sudo nmap -v -A -T4 10.5.11.0/28 -oX ../dmz.xml && sudo xsltproc ../dmz.xml -o ../dmz.html

sudo git add -A && sudo git commit -m "ubuntu server nmap scans" && sudo git push origin master 
