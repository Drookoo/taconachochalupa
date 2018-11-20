apt install nmap 

sudo apt install xsltproc 

nmap -A 172.20.241.0/24 -oX internal.xml && xsltproc internal.xml -o date dmz.html

sudo rm -rf internal.xml

nmap -A 172.20.240.0/24 -oX dmz.xml && xsltproc dmz.xml -o dmz.html

sudo rm dmz.mxl 
