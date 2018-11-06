#!/usr/bin/env bash

# Author:   Zhang Huangbin (zhb _at_ iredmail.org)
# Purpose:  Install & config necessary packages for iRedAdmin.

#---------------------------------------------------------------------
# This file is part of iRedMail, which is an open source mail server
# solution for Red Hat(R) Enterprise Linux, CentOS, Debian and Ubuntu.
#
# iRedMail is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# iRedMail is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with iRedMail.  If not, see <http://www.gnu.org/licenses/>.
#---------------------------------------------------------------------

iredadmin_install()
{
    ECHO_INFO "Configure iRedAdmin (official web-based admin panel)."

    cd ${PKG_MISC_DIR}

    # Extract source tarball.
    extract_pkg ${IREDADMIN_TARBALL} ${HTTPD_SERVERROOT}

    # Create symbol link, so that we don't need to modify web server config
    # file to set new version number after upgrading this software.
    ln -s ${IREDADMIN_HTTPD_ROOT} ${IREDADMIN_HTTPD_ROOT_SYMBOL_LINK} >> ${INSTALL_LOG} 2>&1

    ECHO_DEBUG "Set correct permission for iRedAdmin: ${IREDADMIN_HTTPD_ROOT}."
    chown -R ${SYS_USER_IREDADMIN}:${SYS_GROUP_IREDADMIN} ${IREDADMIN_HTTPD_ROOT}
    chmod -R 0555 ${IREDADMIN_HTTPD_ROOT}

    echo 'export status_iredadmin_install="DONE"' >> ${STATUS_FILE}
}

iredadmin_web_config() {
    # Copy sample configure file.
    cd ${IREDADMIN_HTTPD_ROOT}/

    if [ X"${BACKEND}" == X'OPENLDAP' ]; then
        cp settings.py.ldap.sample settings.py
    elif [ X"${BACKEND}" == X'MYSQL' ]; then
        cp settings.py.mysql.sample settings.py
    elif [ X"${BACKEND}" == X'PGSQL' ]; then
        cp settings.py.pgsql.sample settings.py
    fi

    chown -R ${SYS_USER_IREDADMIN}:${SYS_GROUP_IREDADMIN} settings.py
    chmod 0400 settings.py

    if [ X"${DISTRO}" == X'OPENBSD' ]; then
        # Change file owner
        # iRedAdmin is not running as user 'iredadmin' on OpenBSD
        chown -R ${HTTPD_USER}:${HTTPD_GROUP} settings.py
    fi

    echo 'export status_iredadmin_web_config="DONE"' >> ${STATUS_FILE}
}

iredadmin_initialize_db() {
    ECHO_DEBUG "Import iRedAdmin database template."
    if [ X"${BACKEND}" == X'OPENLDAP' -o X"${BACKEND}" == X'MYSQL' ]; then
        # Required by MySQL-5.6: TEXT/BLOB column cannot have a default value.
        perl -pi -e 's#(.*maildir.*)TEXT(.*)#${1}VARCHAR\(255\)${2}#g' ${IREDADMIN_HTTPD_ROOT}/SQL/iredadmin.mysql;

        ${MYSQL_CLIENT_ROOT} <<EOF
# Create databases.
CREATE DATABASE IF NOT EXISTS ${IREDADMIN_DB_NAME} DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

# Import SQL template.
USE ${IREDADMIN_DB_NAME};
SOURCE ${IREDADMIN_HTTPD_ROOT}/SQL/iredadmin.mysql;
GRANT ALL ON ${IREDADMIN_DB_NAME}.* TO '${IREDADMIN_DB_USER}'@'${MYSQL_GRANT_HOST}' IDENTIFIED BY '${IREDADMIN_DB_PASSWD}';
-- GRANT ALL ON ${IREDADMIN_DB_NAME}.* TO '${IREDADMIN_DB_USER}'@'${HOSTNAME}' IDENTIFIED BY '${IREDADMIN_DB_PASSWD}';
FLUSH PRIVILEGES;
EOF

        # Generate .my.cnf file
        cat > /root/.my.cnf-${IREDADMIN_DB_USER} <<EOF
[client]
host=${MYSQL_SERVER_ADDRESS}
port=${MYSQL_SERVER_PORT}
user=${IREDADMIN_DB_USER}
password="${IREDADMIN_DB_PASSWD}"
EOF

    elif [ X"${BACKEND}" == X'PGSQL' ]; then
        cp -f ${IREDADMIN_HTTPD_ROOT_SYMBOL_LINK}/SQL/iredadmin.pgsql ${PGSQL_DATA_DIR}/ >/dev/null
        chmod 0777 ${PGSQL_DATA_DIR}/iredadmin.pgsql >/dev/null
        su - ${SYS_USER_PGSQL} -c "psql -d template1" >> ${INSTALL_LOG} 2>&1 <<EOF
-- Create user
CREATE USER ${IREDADMIN_DB_USER} WITH ENCRYPTED PASSWORD '${IREDADMIN_DB_PASSWD}' NOSUPERUSER NOCREATEDB NOCREATEROLE;

-- Create database
CREATE DATABASE ${IREDADMIN_DB_NAME} WITH TEMPLATE template0 ENCODING 'UTF8';

-- Grant privilege
ALTER DATABASE ${IREDADMIN_DB_NAME} OWNER TO ${IREDADMIN_DB_USER};
EOF

        su - ${SYS_USER_PGSQL} -c "psql -U ${IREDADMIN_DB_USER} -d ${IREDADMIN_DB_NAME}" >> ${INSTALL_LOG} 2>&1 <<EOF
-- Import SQL template
\i ${PGSQL_DATA_DIR}/iredadmin.pgsql;
EOF
        rm -f ${PGSQL_DATA_DIR}/iredadmin.pgsql
    fi

    echo 'export status_iredadmin_initialize_db="DONE"' >> ${STATUS_FILE}
}

iredadmin_config() {
    ECHO_DEBUG "Configure iRedAdmin."

    # Update iRedAdmin config file.
    ECHO_DEBUG "Configure general settings."
    perl -pi -e 's#^(webmaster =).*#${1} "$ENV{DOMAIN_ADMIN_EMAIL}"#' settings.py
    perl -pi -e 's#^(storage_base_directory =).*#${1} "$ENV{STORAGE_MAILBOX_DIR}"#' settings.py
    perl -pi -e 's#^(default_mta_transport =).*#${1} "$ENV{TRANSPORT}"#' settings.py

    ECHO_DEBUG "Configure iredadmin database related settings."
    perl -pi -e 's#^(iredadmin_db_host =).*#${1} "$ENV{SQL_SERVER_ADDRESS}"#' settings.py
    perl -pi -e 's#^(iredadmin_db_port =).*#${1} "$ENV{SQL_SERVER_PORT}"#' settings.py
    perl -pi -e 's#^(iredadmin_db_name =).*#${1} "$ENV{IREDADMIN_DB_NAME}"#' settings.py
    perl -pi -e 's#^(iredadmin_db_user =).*#${1} "$ENV{IREDADMIN_DB_USER}"#' settings.py
    perl -pi -e 's#^(iredadmin_db_password =).*#${1} "$ENV{IREDADMIN_DB_PASSWD}"#' settings.py

    # Backend related settings.
    if [ X"${BACKEND}" == X'OPENLDAP' ]; then
        ECHO_DEBUG "Configure OpenLDAP backend related settings."
        perl -pi -e 's#^(ldap_uri =).*#${1} "ldap://$ENV{LDAP_SERVER_HOST}:$ENV{LDAP_SERVER_PORT}"#' settings.py
        perl -pi -e 's#^(ldap_basedn =).*#${1} "$ENV{LDAP_BASEDN}"#' settings.py
        perl -pi -e 's#^(ldap_domainadmin_dn =).*#${1} "$ENV{LDAP_ADMIN_BASEDN}"#' settings.py
        perl -pi -e 's#^(ldap_bind_dn =).*#${1} "$ENV{LDAP_ADMIN_DN}"#' settings.py
        perl -pi -e 's#^(ldap_bind_password =).*#${1} "$ENV{LDAP_ADMIN_PW}"#' settings.py

    elif [ X"${BACKEND}" == X'MYSQL' -o X"${BACKEND}" == X'PGSQL' ]; then
        ECHO_DEBUG "Configure SQL mail accounts related settings."
        perl -pi -e 's#^(vmail_db_host =).*#${1} "$ENV{SQL_SERVER_ADDRESS}"#' settings.py
        perl -pi -e 's#^(vmail_db_port =).*#${1} "$ENV{SQL_SERVER_PORT}"#' settings.py
        perl -pi -e 's#^(vmail_db_name =).*#${1} "$ENV{VMAIL_DB_NAME}"#' settings.py
        perl -pi -e 's#^(vmail_db_user =).*#${1} "$ENV{VMAIL_DB_ADMIN_USER}"#' settings.py
        perl -pi -e 's#^(vmail_db_password =).*#${1} "$ENV{VMAIL_DB_ADMIN_PASSWD}"#' settings.py
    fi

    # Disable Policyd/Cluebringer
    perl -pi -e 's#^(policyd_enabled =).*#${1} False#' settings.py

    # Amavisd.
    ECHO_DEBUG "Configure Amavisd related settings."
    perl -pi -e 's#^(amavisd_db_host =).*#${1} "$ENV{SQL_SERVER_ADDRESS}"#' settings.py
    perl -pi -e 's#^(amavisd_db_port =).*#${1} "$ENV{SQL_SERVER_PORT}"#' settings.py
    perl -pi -e 's#^(amavisd_db_name =).*#${1} "$ENV{AMAVISD_DB_NAME}"#' settings.py
    perl -pi -e 's#^(amavisd_db_user =).*#${1} "$ENV{AMAVISD_DB_USER}"#' settings.py
    perl -pi -e 's#^(amavisd_db_password =).*#${1} "$ENV{AMAVISD_DB_PASSWD}"#' settings.py

    perl -pi -e 's#^(amavisd_enable_logging =).*#${1} True#' settings.py
    perl -pi -e 's#^(amavisd_enable_quarantine =).*#${1} True#' settings.py
    perl -pi -e 's#^(amavisd_enable_policy_lookup=).*#${1} True#' settings.py
    perl -pi -e 's#^(amavisd_quarantine_port =).*#${1} "$ENV{AMAVISD_QUARANTINE_PORT}"#' settings.py

    ECHO_DEBUG "Configure iRedAPD related settings."
    perl -pi -e 's#^(iredapd_enabled =).*#${1} True#' settings.py
    perl -pi -e 's#^(iredapd_db_host =).*#${1} "$ENV{SQL_SERVER_ADDRESS}"#' settings.py
    perl -pi -e 's#^(iredapd_db_port =).*#${1} "$ENV{SQL_SERVER_PORT}"#' settings.py
    perl -pi -e 's#^(iredapd_db_name =).*#${1} "$ENV{IREDAPD_DB_NAME}"#' settings.py
    perl -pi -e 's#^(iredapd_db_user =).*#${1} "$ENV{IREDAPD_DB_USER}"#' settings.py
    perl -pi -e 's#^(iredapd_db_password =).*#${1} "$ENV{IREDAPD_DB_PASSWD}"#' settings.py

    echo "DEFAULT_PASSWORD_SCHEME = '${DEFAULT_PASSWORD_SCHEME}'" >> settings.py
    echo "mlmmjadmin_api_auth_token = '${MLMMJADMIN_API_AUTH_TOKEN}'" >> settings.py

    # Add postfix alias for user: iredapd
    add_postfix_alias ${SYS_USER_IREDAPD} ${SYS_ROOT_USER}

    cat >> ${TIP_FILE} <<EOF
iRedAdmin - official web-based admin panel:
    * Version: ${IREDADMIN_VERSION}
    * Root directory: ${IREDADMIN_HTTPD_ROOT}
    * Config file: ${IREDADMIN_HTTPD_ROOT}/settings.py
    * Web access:
        - URL: https://${HOSTNAME}/iredadmin/
        - Username: ${DOMAIN_ADMIN_NAME}@${FIRST_DOMAIN}
        - Password: ${DOMAIN_ADMIN_PASSWD_PLAIN}
    * SQL database:
        - Database name: ${IREDADMIN_DB_NAME}
        - Username: ${IREDADMIN_DB_USER}
        - Password: ${IREDADMIN_DB_PASSWD}

EOF

    echo 'export status_iredadmin_config="DONE"' >> ${STATUS_FILE}
}

iredadmin_cron_setup()
{
    cat >> ${CRON_FILE_ROOT} <<EOF
# ${PROG_NAME}: Cleanup Amavisd database
1   2   *   *   *   ${PYTHON_BIN} ${IREDADMIN_HTTPD_ROOT_SYMBOL_LINK}/tools/cleanup_amavisd_db.py >/dev/null

# iRedAdmin: Clean up sql database.
1   *   *   *   *   ${PYTHON_BIN} ${IREDADMIN_HTTPD_ROOT_SYMBOL_LINK}/tools/cleanup_db.py >/dev/null 2>&1

# iRedAdmin: Delete mailboxes on file system which belong to removed accounts.
1   *   *   *   *   ${PYTHON_BIN} ${IREDADMIN_HTTPD_ROOT_SYMBOL_LINK}/tools/delete_mailboxes.py
EOF

    # Disable cron jobs if we don't need to initialize database on this server.
    if [ X"${INITIALIZE_SQL_DATA}" != X'YES' ]; then
        perl -pi -e 's/(.*iredadmin.*tools.*cleanup_amavisd_db.py.*)/#${1}/g' ${CRON_FILE_ROOT}
    fi

    echo 'export status_iredadmin_cron_setup="DONE"' >> ${STATUS_FILE}
}

iredadmin_uwsgi_setup()
{
    backup_file ${IREDADMIN_UWSGI_CONF}
    cp ${SAMPLE_DIR}/uwsgi/iredadmin.ini ${IREDADMIN_UWSGI_CONF}

    if [ X"${DISTRO}" == X'RHEL' ]; then
        :
    elif [ X"${DISTRO}" == X'DEBIAN' -o X"${DISTRO}" == X'UBUNTU' ]; then
        perl -pi -e 's/^(pidfile.*)/#${1}/' ${IREDADMIN_UWSGI_CONF}
        ln -s ${IREDADMIN_UWSGI_CONF} /etc/uwsgi/apps-enabled/iredadmin.ini

    elif [ X"${DISTRO}" == X'FREEBSD' ]; then
        perl -pi -e 's/^(plugins.*)/#${1}/' ${IREDADMIN_UWSGI_CONF}
        perl -pi -e 's#PH_UWSGI_LOG_FILE#$ENV{UWSGI_LOG_FILE}#g' ${IREDADMIN_UWSGI_CONF}
        perl -pi -e 's#PH_IREDADMIN_UWSGI_PID#$ENV{IREDADMIN_UWSGI_PID}#g' ${IREDADMIN_UWSGI_CONF}

        service_control enable 'uwsgi_iredadmin_flags' "--ini ${IREDADMIN_UWSGI_CONF}"

        # Rotate log file with newsyslog
        cp -f ${SAMPLE_DIR}/freebsd/newsyslog.conf.d/uwsgi-iredadmin ${UWSGI_LOGROTATE_FILE}
        perl -pi -e 's#PH_IREDADMIN_UWSGI_PID#$ENV{IREDADMIN_UWSGI_PID}#g' ${UWSGI_LOGROTATE_FILE}

    elif [ X"${DISTRO}" == X'OPENBSD' ]; then
        perl -pi -e 's#^(uid).*#${1} = $ENV{HTTPD_USER}#g' ${IREDADMIN_UWSGI_CONF}
        perl -pi -e 's#^(gid).*#${1} = $ENV{HTTPD_GROUP}#g' ${IREDADMIN_UWSGI_CONF}
        perl -pi -e 's/^(plugins.*)/#${1}/g' ${IREDADMIN_UWSGI_CONF}

        rcctl set uwsgi flags "--ini ${IREDADMIN_UWSGI_CONF} --log-syslog" >> ${INSTALL_LOG} 2>&1
    fi

    if [ -f ${IREDADMIN_UWSGI_CONF} ]; then
        perl -pi -e 's#PH_HTTPD_USER#$ENV{HTTPD_USER}#g' ${IREDADMIN_UWSGI_CONF}
        perl -pi -e 's#PH_HTTPD_GROUP#$ENV{HTTPD_GROUP}#g' ${IREDADMIN_UWSGI_CONF}
        perl -pi -e 's#PH_IREDADMIN_UWSGI_SOCKET#$ENV{IREDADMIN_UWSGI_SOCKET}#g' ${IREDADMIN_UWSGI_CONF}
        perl -pi -e 's#PH_IREDADMIN_UWSGI_PID#$ENV{IREDADMIN_UWSGI_PID}#g' ${IREDADMIN_UWSGI_CONF}
    fi

    cat >> ${TIP_FILE} <<EOF
    * Socket for iRedAdmin: ${IREDADMIN_UWSGI_SOCKET}
EOF

    echo 'export status_iredadmin_uwsgi_setup="DONE"' >> ${STATUS_FILE}
}

iredadmin_setup() {
    check_status_before_run iredadmin_install
    check_status_before_run iredadmin_web_config

    if [ X"${INITIALIZE_SQL_DATA}" == X'YES' ]; then
        check_status_before_run iredadmin_initialize_db
    fi

    check_status_before_run iredadmin_cron_setup
    check_status_before_run iredadmin_config
    check_status_before_run iredadmin_uwsgi_setup

    echo 'export status_iredadmin_setup="DONE"' >> ${STATUS_FILE}
}
