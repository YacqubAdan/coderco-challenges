#!/bin/bash

set -e

DIR="/opt/coderco-app"
SERVICE_FILE="coderco-app.service"
SERVICE_DIR="/etc/systemd/system"
LOG_FILE="/var/log/coderco-app.log"
HEALTHCHECK_SCRIPT="healthcheck.sh"
CRON_FILE="/etc/cron.d/coderco-healthcheck"

if id "appuser" &>/dev/null; then
    echo "User appuser already exists..."
else
    echo "Creating user: appuser"
    sudo useradd appuser
    echo "Set a password for user: appuser"
    sudo passwd appuser
fi

echo "Creating directory..."
sudo mkdir -p "$DIR"

echo "Copy app folder to directory"
sudo cp server.py .env "$DIR"
sudo cp "$SERVICE_FILE" "$SERVICE_DIR" 

echo "Setting permissions for appuser..."
sudo chown -R appuser:appuser "$DIR"
sudo chmod -R 700 "$DIR"

echo "Creating log file with correct permissions..."
sudo touch "$LOG_FILE"
sudo chown appuser:appuser "$LOG_FILE"
sudo chmod 640 "$LOG_FILE"

echo "Setting up cron job for healthcheck..."
echo "* * * * * ubuntu /home/ubuntu/healthcheck.sh" | sudo tee "$CRON_FILE" > /dev/null
sudo chmod 644 "$CRON_FILE"
sudo systemctl restart cron


sudo systemctl daemon-reload
sudo systemctl enable coderco-app.service
sudo systemctl start coderco-app.service

echo "setting firewall rules"
sudo ufw default deny incoming
sudo ufw allow 22/tcp
sudo ufw allow in on lo to any port 8080 proto tcp
sudo ufw --force enable
echo "Setup complete."
