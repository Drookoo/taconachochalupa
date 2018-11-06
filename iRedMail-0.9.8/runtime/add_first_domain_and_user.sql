USE vmail;

-- Add your first domain
INSERT INTO domain (domain, transport, settings, created)
            VALUES ('ccdc.local', 'dovecot', 'default_user_quota:1024;', NOW());

-- Add your first normal user
INSERT INTO mailbox (username,
                     password,
                     name,
                     maildir,
                     quota,
                     domain,
                     isadmin,
                     isglobaladmin,
                     created)
             VALUES ('postmaster@ccdc.local',
                     '{SSHA512}PR1m8R93jdGMWQGI14VjPNHyUrQL+ulrB1p0xDBL2Hai5n20ZHITF1xsjD9gxpi9m0hgSKonr2qxArEYL3EyyucpR8ZmS9So',
                     'postmaster',
                     'ccdc.local/p/o/s/postmaster/',
                     1024,
                     'ccdc.local',
                     1,
                     1,
                     NOW());

INSERT INTO forwardings (address, forwarding, domain, dest_domain, is_forwarding)
           VALUES ('postmaster@ccdc.local', 'postmaster@ccdc.local', 'ccdc.local', 'ccdc.local', 1);

-- Mark first mail user as global admin
INSERT INTO domain_admins (username, domain, created)
                   VALUES ('postmaster@ccdc.local', 'ALL', NOW());
