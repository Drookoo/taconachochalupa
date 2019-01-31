#!/bin/bash
#=======================================================================================
#=== DESCIPTION ========================================================================
#=======================================================================================
	## sets up tmux session broken into several panels
	## for easy access to current log info
	##
#=======================================================================================
#=======================================================================================
	#
	#*************** NEED TO DO/ADD ***********************
	# decide which log files to keep track of..
	# create tmux layout, naming scheme, etc
	## w / who / who am i
	#### GENERAL
	##
	#### NETWORK
	## ss / netstat / vnstat / iftop / nload / jnettop
	# netstat -tulpnac
	#### SYSTEM RESOURCES
	##
	#### DISKS
	## dstat / discus
	#### MEMORY
	## vmstat / free
	#******************************************************
	#
#///////////////////////////////////////////////////////////////////////////////////////
#|||||||||||||||||||||||| Script Stuff Starts |||||||||||||||||||||||||||||||||||||||||
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
#### RUN function #####
#######################
function main(){	###
	function1		###
	function2		###
}					###
#######################
#------ error handling ----------
### If error, give up			#
#set -e							#
#- - - - - - - - - - - - - - - -#
### if error, do THING			#
# makes trap global 			#
# (works in functions)			#
#set -o errtrace				#
# 'exit' can be a func or cmd	#
#trap 'exit' ERR				#
#--------------------------------
backupDir="$HOME""/ccdc_backups/$(basename "$0" | sed 's/\.sh$//')"
###########################################################################################
#FUNCTION1 description
###########################################################################################
#TS: troubleshooting hint
#----------------------
function1(){
	#### PART 1 ############################
	}

###########################################################################################
#FUNCTION2 description
###########################################################################################
#TS: troubleshooting hint
#----------------------
function2(){
	#### PART 1 ############################
	}


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++ FIGHT!! +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

main