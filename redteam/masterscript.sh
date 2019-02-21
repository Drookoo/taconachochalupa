#!/bin/bash 

#################################################
#
#    Script Name: masterscript.sh
#    Script Author: Https://github.com/drookoo
#    Usage: masterscript.sh <ip.addr>
#
#################################################

###############    Housekeeping     #############
sudo apt-get install -y nmap 
addr="$1"

#################################################

sudo nmap -A $1 
sudo nmap -sU -v $1
#save both scans to file 

sudo dirb https://$1