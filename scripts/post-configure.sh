#!/bin/bash

set -e

echo "### Configuring PostgreSQL to listen on all interfaces ###"

NETWORK="192.168.1.1/24"
PG_CONFIG_DIR=$(find /etc/postgresql -type d -name "main" | sort -r | head -n 1)

if [ -z "$PG_CONFIG_DIR" ]; then
    echo "Error: Could not find PostgreSQL configuration directory."
    exit 1
fi

PG_CONF_FILE="$PG_CONFIG_DIR/postgresql.conf"
PG_HBA_FILE="$PG_CONFIG_DIR/pg_hba.conf"

echo "--> Found configuration directory: $PG_CONFIG_DIR"

# Step 2: Modify postgresql.conf to listen on all IP addresses
echo "--> Setting listen_addresses to '*' in $PG_CONF_FILE"
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" "$PG_CONF_FILE"


echo "--> Allowing connections from all hosts in $PG_HBA_FILE"
echo "host    all             all            0.0.0.0/0              scram-sha-256" | sudo tee -a "$PG_HBA_FILE" > /dev/null

# Step 4: Open port 5432 in the firewall
echo "--> Opening firewall port 5432/tcp"
sudo ufw allow 5432/tcp

# Step 5: Restart the PostgreSQL service for changes to take effect
echo "--> Restarting PostgreSQL service..."
sudo systemctl restart postgresql

echo "### Configuration complete. PostgreSQL now listens on all network interfaces. ###"

#  psql -h 192.168.1.5 -U postgres