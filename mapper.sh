nmap -sP 172.16.1.0/24 -oX mapper.xml && sudo xsltproc  mapper.xml -o mapper.html 
