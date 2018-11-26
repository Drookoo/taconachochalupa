# see see dee see 

nmap -A 172.20.241.0/24 -oX dansscan2.xml && xsltproc dansscan2.xml -o date +%m%d%y_report.html


dpkg -i Nessus.deb

/etc/init.d/nessusd start

https://mx.ccdc.local:8834/

how to run shellscript:
chmod +x <filename>
./<filename>

when scanning centos, must add -Pn because centos blocks all pings by default its fw 
