#!/bin/bash
txtbld=$(tput bold)
bldred=${txtbld}$(tput setaf 1)
txtrst=$(tput sgr0)

binarypathchk (){
		echo -e "${txtlbd}You're checking $1${txtrst}"
			argpath=$(type $1)
				echo -e "${txtbld}Do these match? Do they seem sane?${txtrst}"
					type $1
						command -v $1
							whereis $1
						}

						if [[ $1 = "" ]]; then
								echo -e "${txtbld}A command must given as an argument${txtrst}"
									exit
								fi

								echo -e "${bldred}This script is not a substitute for knowing how to computer.\nCheck your aliases before running this script!\nStay alert and doubt everything.\nMay the force be with you...\n${txtrst}"
								echo -e "${txtbld}Check for Malicious/Strange Folders${txtrst}\n"
								echo $PATH

								echo -e "${txtbld}Is the path correct?\n[y/n]\nIf not, enter the correct path.${txtrst}"

								read pathchk

								if [[ $pathchk = [Nn] ]]; then
										echo -e "${txtbld}Enter the correct path in this format PATH=\"/some/dir:/other/dir\"${txtrst}"
											read newpath
												source $newpath
													echo -e "${txtbld}New \$PATH set\nThis will only be in effect for the duration of this script" \n""
														echo -e "Use caution, check .bash_rc, .bash_profile, /etc/bash_profile, etc\n${txtrst}"
													fi

													binarypathchk "$1"

													echo "${txtbld}Is this a symlink?[y/n]${txtrst}"
													read sympath

													if [[ $sympath = [Yy] ]]; then
															echo -e "${txtbld}If so enter the linked path of the command\n"
																echo -e "Format \"/some/dir\"${txtrst}"
																	read argpath
																		binarypathchk "$argpath"
																	fi

																	echo -e "${txtbld}Does the filetype seem correct?\n${txtrst}"
																	file $argpath 

																	echo -e "${txtbld}Would you like to check the binary's strings?\n[y/n]${txtrst}" 
																	read stringchk

																	if [[ $stringchk = [Yy] ]]; then
																			strings $argpath
																				echo -e "${txtbld}Does that look normal?\n${txtrst}"
																			else
																					echo -e "${txtbld}Done checking command.\n${txtrst}"
																				fi
