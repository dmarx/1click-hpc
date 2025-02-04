#!/bin/bash
set -e

sed -i '0,/use_fully_qualified_names = False$/s//use_fully_qualified_names = False\nldap_user_extra_attrs = altSecurityIdentities\nldap_user_ssh_public_key = altSecurityIdentities/' /etc/sssd/sssd.conf
#systemctl stop sssd
#rm -rf /var/lib/sss/{db,mc}/*
#systemctl start sssd
echo "AuthorizedKeysCommand /usr/bin/sss_ssh_authorizedkeys" >> /etc/ssh/sshd_config
echo "AuthorizedKeysCommandUser root" >> /etc/ssh/sshd_config
systemctl restart sshd
