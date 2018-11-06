-- Create database for virtual hosts
CREATE DATABASE IF NOT EXISTS vmail CHARACTER SET utf8;

-- Permissions
GRANT SELECT ON vmail.* TO 'vmail'@'localhost' IDENTIFIED BY 'SVQasSsAaGw1x7FCFdwBA1ctdoYeXB';
-- GRANT SELECT ON vmail.* TO 'vmail'@'mx.ccdc.local' IDENTIFIED BY 'SVQasSsAaGw1x7FCFdwBA1ctdoYeXB';
GRANT SELECT,INSERT,DELETE,UPDATE ON vmail.* TO 'vmailadmin'@'localhost' IDENTIFIED BY 'X9aJKk3YJPhoVKODkZq2AMZq78Uuuq';
-- GRANT SELECT,INSERT,DELETE,UPDATE ON vmail.* TO 'vmailadmin'@'mx.ccdc.local' IDENTIFIED BY 'X9aJKk3YJPhoVKODkZq2AMZq78Uuuq';

FLUSH PRIVILEGES;
