#!/bin/bash

sudo apt update && sudo apt upgrade -y
sudo apt install -y postgresql postgresql-contrib
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '"${secret}"';"
sudo su - postgres << EOF
echo "host all all 0.0.0.0/0 scram-sha-256" >> /etc/postgresql/14/main/pg_hba.conf
echo "listen_addresses = '*'" >> /etc/postgresql/14/main/postgresql.conf
createdb ${database}
EOF
sudo su -c "echo \"postgres ALL=(ALL) NOPASSWD:ALL\" | tee /etc/sudoers.d/postgres"
sudo systemctl restart postgresql
sudo sleep 10
export newp=${secret}
sudo usermod -p "$(perl -s -e 'print crypt("$ENV{newp}", "salt"),"\n"')" postgres



