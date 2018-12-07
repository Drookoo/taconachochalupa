sys_upgrades() {
	    yum -y update
	        yum -y upgrade
		    yum -y autoremove
	    }

permission_narrowing() {
	    chmod 700 /root
	        chmod 700 /var/log/audit
		    chmod 740 /etc/rc.d/init.d/iptables
		        chmod 740 /sbin/iptables
			    chmod  700 /etc/skel
			        chmod 600 /etc/rsyslog.conf
				    chmod 640 /etc/security/access.conf
				        chmod 600 /etc/sysctl.conf
				}

disable_avahi(){
	    systemctl stop avahi-daemon.socket avahi-daemon.service
	        systemctl disable avahi-daemon.socket avahi-daemon.service
	}





	disable_postfix() {
		    systemctl stop postfix
		        systemctl disable postfix
		}

main() {
	    sys_upgrades
				        permission_narrowing
					    disable_avahi
					        disable_postfix
					    }

					    main "$@"



