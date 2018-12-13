sys_upgrades() {
	    yum -y update
	    yum -y upgrade
		yum -y autoremove
	    }

permission_narrowing() {
	    chmod 700 /root
	    chmod 700 /var/log/audit
		chmod 740 /etc/sysconfig/iptables-config
		chmod 740 /etc/sysconfig/firewalld
		chmod 740 /sbin/iptables
		chmod  700 /etc/skel
		chmod 600 /etc/rsyslog.conf
		chmod 640 /etc/security/access.conf
		chmod 600 /etc/sysctl.conf
				}

disable_postfix() {
		systemctl stop postfix
		systemctl disable postfix
	}

main() {
	    sys_upgrades
		permission_narrowing
		disable_postfix
	}

main "$@"



