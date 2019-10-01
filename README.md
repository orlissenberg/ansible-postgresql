## PostgreSQL

Ansible role which installs and configures PostgreSQL, extensions, databases and users.

[pgAdmin](http://www.pgadmin.org/)

#### Requirements & Dependencies
- Tested on Ansible 1.8.4 or higher.

#### Variables

```yaml
# Basic settings
postgresql_version: 9.3
postgresql_encoding: 'UTF-8'
postgresql_locale: 'en_US.UTF-8'

postgresql_admin_user: "postgres"
postgresql_default_auth_method: "trust"

postgresql_cluster_name: "main"
postgresql_cluster_reset: false

# List of databases to be created (optional)
postgresql_databases:
  - name: foobar
    hstore: yes         # flag to install the hstore extension on this database (yes/no)
    uuid_ossp: yes      # flag to install the uuid-ossp extension on this database (yes/no)

# List of users to be created (optional)
postgresql_users:
  - name: baz
    pass: pass
    encrypted: no       # denotes if the password is already encrypted.

# List of user privileges to be applied (optional)
postgresql_user_privileges:
  - name: baz                   # user name
    db: foobar                  # database
    priv: "ALL"                 # privilege string format: example: INSERT,UPDATE/table:SELECT/anothertable:ALL
    role_attr_flags: "CREATEDB" # role attribute flags
```
There's a lot more knobs and bolts to set, which you can find in the defaults/main.yml

#### License

Licensed under the MIT License. See the LICENSE file for details.

#### Thanks

To the contributors:
- [Ralph von der Heyden](https://github.com/ralph)
- ANXS

#### Issues

    postgresql-contrib-9.4 : Depends: postgresql-9.4 (= 9.4.13-0+deb8u1) but 9.4.12-1.pgdg80+1 is to be installed
    > sudo apt-get -f install
    > sudo apt list --installed | grep postgresql
    > sudo apt-get upgrade
    > sudo apt-get remove postgresql-contrib-9.4
    and reinstall after ...

#### Feedback, bug-reports, requests, ...

Are welcome!
