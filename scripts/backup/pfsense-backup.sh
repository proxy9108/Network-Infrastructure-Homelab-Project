#!/bin/bash
# pfSense automatic backup via SSH/SCP

PFSENSE_HOST="192.168.20.1"
BACKUP_DIR="/backup/pfsense"
DATE=$(date +%Y%m%d_%H%M%S)

# Would need to configure passwordless SSH first
# This is a template - actual implementation depends on your setup

echo "Backing up pfSense config..."
# scp root@${PFSENSE_HOST}:/cf/conf/config.xml ${BACKUP_DIR}/config_${DATE}.xml

# Keep last 30 backups
find ${BACKUP_DIR} -name "config_*.xml" -mtime +30 -delete
