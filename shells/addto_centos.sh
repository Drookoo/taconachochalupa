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

	
##### Delete this line
kernel_tuning() {
    sysctl kernel.randomize_va_space=1
    
    # Enable IP spoofing protection
    sysctl net.ipv4.conf.all.rp_filter=1

    # Disable IP source routing
    sysctl net.ipv4.conf.all.accept_source_route=0
    
    # Ignoring broadcasts request
    sysctl net.ipv4.icmp_echo_ignore_broadcasts=1
    sysctl net.ipv4.icmp_ignore_bogus_error_messages=1
    
    # Make sure spoofed packets get logged
    sysctl net.ipv4.conf.all.log_martians=1
    sysctl net.ipv4.conf.default.log_martians=1

    # Disable ICMP routing redirects
    sysctl -w net.ipv4.conf.all.accept_redirects=0
    sysctl -w net.ipv6.conf.all.accept_redirects=0
    sysctl -w net.ipv4.conf.all.send_redirects=0
    sysctl -w net.ipv6.conf.all.send_redirects=0

    # Disables the magic-sysrq key
    sysctl kernel.sysrq=0
    
    # Turn off the tcp_timestamps
    sysctl net.ipv4.tcp_timestamps=0

    # Enable TCP SYN Cookie Protection
    sysctl net.ipv4.tcp_syncookies=1

    # Enable bad error message Protection
    sysctl net.ipv4.icmp_ignore_bogus_error_responses=1
    
    # RELOAD WITH NEW SETTINGS
    sysctl -p
}

disable_ipv6() {
    sysctl -w net.ipv6.conf.default.disable_ipv6=1
    sysctl -w net.ipv6.conf.all.disable_ipv6=1
}

main() {
	    sys_upgrades
		permission_narrowing
		disable_postfix
		kernel_tuning
		disable_ipv6
	}

main "$@"



