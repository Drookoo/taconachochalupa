#!/bin/bash
#./ubuntu-internal.sh
#ubuntu internal machine

source helpers.sh

#sudo git clone https://github.com/drookoo/taconachochalupa.git
#cd taconachochalupa
#sudo chmod +x ./ubuntu-server.sh

#just in case?
sudo apt install nmap 
sudo apt install xsltproc 

sudo nmap -v -A -T4 172.16.5.0/24 -oX ../internal.xml && sudo xsltproc ../internal.xml -o ../internal.html

sudo nmap -v -A -T4 10.5.11.0/28 -oX ../dmz.xml && sudo xsltproc ../dmz.xml -o ../dmz.html

sudo git config --global user.email "andrewku123@gmail.com"

sudo git add -A && sudo git commit -m "ubuntu server nmap scans" && sudo git push origin master 

# Configure TimeZone
config_timezone(){
   clear
   echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
   echo -e "\e[93m[+]\e[00m We will now Configure the TimeZone"
   echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
   echo ""
   sleep 10
   dpkg-reconfigure tzdata
   say_done
}

  ##############################################################################################################


# Update System, Install sysv-rc-conf tool
update_system(){
	clear
	echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
	echo -e "\e[93m[+]\e[00m Updating the System"
	echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
	echo ""
	apt update
	apt upgrade -y
	apt dist-upgrade -y
	say_done
	}

##############################################################################################################

#Disabling Unused Filesystems

unused_filesystems(){
	clear
	echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
	echo -e "\e[93m[+]\e[00m Disabling Unused FileSystems"
	echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
	echo ""
	spinner
	echo "install cramfs /bin/true" >> /etc/modprobe.d/CIS.conf
	echo "install freevxfs /bin/true" >> /etc/modprobe.d/CIS.conf
	echo "install jffs2 /bin/true" >> /etc/modprobe.d/CIS.conf
	echo "install hfs /bin/true" >> /etc/modprobe.d/CIS.conf
	echo "install hfsplus /bin/true" >> /etc/modprobe.d/CIS.conf
	echo "install squashfs /bin/true" >> /etc/modprobe.d/CIS.conf
	echo "install udf /bin/true" >> /etc/modprobe.d/CIS.conf
	echo "install vfat /bin/true" >> /etc/modprobe.d/CIS.conf
	echo " OK"
	say_done
	}

##############################################################################################################

uncommon_netprotocols(){
	clear
	echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
	echo -e "\e[93m[+]\e[00m Disabling Uncommon Network Protocols"
	echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
	echo ""
	spinner
	echo "install dccp /bin/true" >> /etc/modprobe.d/CIS.conf
	echo "install sctp /bin/true" >> /etc/modprobe.d/CIS.conf
	echo "install rds /bin/true" >> /etc/modprobe.d/CIS.conf
	echo "install tipc /bin/true" >> /etc/modprobe.d/CIS.conf
	echo " OK"
	say_done
	}

##############################################################################################################

# Disable Compilers
disable_compilers(){
	clear
	echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
	echo -e "\e[93m[+]\e[00m Disabling Compilers"
	echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
	echo ""
	echo "Disabling Compilers....."
	spinner
	chmod 000 /usr/bin/as >/dev/null 2>&1
	chmod 000 /usr/bin/byacc >/dev/null 2>&1
	chmod 000 /usr/bin/yacc >/dev/null 2>&1
	chmod 000 /usr/bin/bcc >/dev/null 2>&1
	chmod 000 /usr/bin/kgcc >/dev/null 2>&1
	chmod 000 /usr/bin/cc >/dev/null 2>&1
	chmod 000 /usr/bin/gcc >/dev/null 2>&1
	chmod 000 /usr/bin/*c++ >/dev/null 2>&1
	chmod 000 /usr/bin/*g++ >/dev/null 2>&1
	spinner
	echo ""
	echo " If you wish to use them, just change the Permissions"
	echo " Example: chmod 755 /usr/bin/gcc "
	echo " OK"
	say_done
	}

##############################################################################################################

file_permissions(){
	clear
	echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
	echo -e "\e[93m[+]\e[00m Setting File Permissions on Critical System Files"
	echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
	echo ""
	spinner
	sleep 2
	chmod -R g-wx,o-rwx /var/log/*

	chown root:root /etc/ssh/sshd_config
	chmod og-rwx /etc/ssh/sshd_config

	chown root:root /etc/passwd
	chmod 644 /etc/passwd

	chown root:shadow /etc/shadow
	chmod o-rwx,g-wx /etc/shadow

	chown root:root /etc/group
	chmod 644 /etc/group

	chown root:shadow /etc/gshadow
	chmod o-rwx,g-rw /etc/gshadow

	chown root:root /etc/passwd-
	chmod 600 /etc/passwd-

	chown root:root /etc/shadow-
	chmod 600 /etc/shadow-

	chown root:root /etc/group-
	chmod 600 /etc/group-

	chown root:root /etc/gshadow-
	chmod 600 /etc/gshadow-


	echo -e ""
	echo -e "Setting Sticky bit on all world-writable directories"
	sleep 2
	spinner

	df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type d -perm -0002 2>/dev/null | xargs chmod a+t

	echo " OK"
	say_done

	}
##############################################################################################################
								   
config_timezone
# update_system
unused_filesystems
disable_compilers
file_permissions
