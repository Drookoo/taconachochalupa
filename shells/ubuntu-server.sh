#sudo git clone https://github.com/drookoo/taconachochalupa.git
#cd taconachochalupa
#sudo chmod +x ./ubuntu-server.sh

#just in case?
sudo apt install nmap 
sudo apt install xsltproc 

sudo nmap -Pn -v -A 172.20.241.0/24 -oX ../internal.xml && sudo xsltproc ../internal.xml -o ../internal.html

sudo nmap -Pn -v -A 172.20.240.0/24 -oX ../dmz.xml && sudo xsltproc ../dmz.xml -o ../dmz.html

sudo git add . && sudo git commit -m "ubuntu server nmap scans" && sudo git push origin master 
