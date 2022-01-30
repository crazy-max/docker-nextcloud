#!/usr/bin/with-contenv sh
# shellcheck shell=sh

CRONTAB_PATH="/var/spool/cron/crontabs"
SIDECAR_CRON=${SIDECAR_CRON:-0}

# Continue only if sidecar cron container
if [ "$SIDECAR_CRON" != "1" ]; then
  exit 0
fi

echo ">>"
echo ">> Sidecar cron container detected for Nextcloud"
echo ">>"

# Init
rm -rf ${CRONTAB_PATH}
mkdir -m 0644 -p ${CRONTAB_PATH}
touch ${CRONTAB_PATH}/nextcloud

# Cron
if [ -n "$CRON_PERIOD" ]; then
  echo "Creating Nextcloud cron task with the following period fields : $CRON_PERIOD"
  echo "${CRON_PERIOD} php -f /var/www/cron.php" >> ${CRONTAB_PATH}/nextcloud
else
  echo "CRON_PERIOD env var empty..."
fi

# Fix perms
echo "Fixing crontabs permissions..."
chmod -R 0644 ${CRONTAB_PATH}

# Create service
mkdir -p /etc/services.d/cron
cat > /etc/services.d/cron/run <<EOL
#!/usr/bin/execlineb -P
with-contenv
exec busybox crond -f -L /dev/stdout
EOL
chmod +x /etc/services.d/cron/run
