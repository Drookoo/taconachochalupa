#sudo git clone https://github.com/drookoo/taconachochalupa.git
#cd taconachochalupa
#sudo chmod +x ./ubuntu-server.sh

#just in case?
sudo apt install nmap 
sudo apt install xsltproc 

sudo nmap -A 172.20.241.0/24 -oX internal.xml && sudo xsltproc internal.xml -o internal.html && sudo rm -rf internal.xml

sudo nmap -A 172.20.240.0/24 -oX dmz.xml && sudo xsltproc dmz.xml -o dmz.html &&sudo rm dmz.xml 
