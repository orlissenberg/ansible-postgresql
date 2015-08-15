#!/usr/bin/env bash

CURRENT_DIR=${PWD}
TMP_DIR=/tmp/ansible-test
mkdir -p $TMP_DIR 2> /dev/null

# Create hosts inventory
cat << EOF > $TMP_DIR/hosts
[webservers]
localhost ansible_connection=local
EOF

# Create group_vars for the webservers
mkdir -p $TMP_DIR/group_vars 2> /dev/null
cat << EOF > $TMP_DIR/group_vars/webservers

postgresql_default_auth_method: "md5"

postgresql_pg_hba_default:
  - type: local
    database: all
    user: '{{ postgresql_admin_user }}'
    address: ''
    method: 'peer'
    comment: ''
  - type: local
    database: all
    user: all
    address: ''
    method: '{{ postgresql_default_auth_method }}'
    comment: '"local" is for Unix domain socket connections only'
  - type: host
    database: all
    user: all
    address: '127.0.0.1/32'
    method: '{{ postgresql_default_auth_method }}'
    comment: 'IPv4 local connections:'
  - type: host
    database: all
    user: all
    address: '::1/128'
    method: '{{ postgresql_default_auth_method }}'
    comment: 'IPv6 local connections:'

postgresql_users:
  - name: testuser
    pass: testpass

postgresql_user_privileges:
  - name: testuser
    role_attr_flags: LOGIN

EOF

# Peer authentication:
# sudo -u postgres psql --username=postgres

# Login as the testuser
# psql --username=testuser --dbname=postgres

# Test MD5 password creating on the command line
# echo "md5`echo -n "testpasstestuser" | md5sum`"

# Show the authentication configuration set by the configure.yml
# sudo less /etc/postgresql/9.3/main/pg_hba.conf

# If restarting is unsuccessful, kill and (re)start.
# sudo ps -aux | grep postgresql
# sudo pkill postgres
# sudo service postgresql restart

# Postgresql client HELP! and user list.
# \?
# \du

# Create Ansible config
cat << EOF > $TMP_DIR/ansible.cfg
[defaults]
roles_path = $CURRENT_DIR/../
host_key_checking = False
EOF

# Create playbook.yml
cat << EOF > $TMP_DIR/playbook.yml
---

- hosts: webservers
  gather_facts: yes
  sudo: yes

  roles:
    - ansible-postgresql
EOF

export ANSIBLE_CONFIG=$TMP_DIR/ansible.cfg

# Syntax check
ansible-playbook $TMP_DIR/playbook.yml -i $TMP_DIR/hosts --syntax-check

# First run
ansible-playbook $TMP_DIR/playbook.yml -i $TMP_DIR/hosts

# Idempotence test
# ansible-playbook $TMP_DIR/playbook.yml -i $TMP_DIR/hosts | grep -q 'changed=0.*failed=0' \
# 	&& (echo 'Idempotence test: pass' && exit 0) \
# 	|| (echo 'Idempotence test: fail' && exit 1)
