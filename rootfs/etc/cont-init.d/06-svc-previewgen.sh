#!/usr/bin/with-contenv sh

CRONTAB_PATH="/var/spool/cron/crontabs"
SIDECAR_PREVIEWGEN=${SIDECAR_PREVIEWGEN:-0}

# Continue only if previewgen container
if [ "$SIDECAR_PREVIEWGEN" != "1" ]; then
  exit 0
fi

echo ">>"
echo ">> Sidecar previews generator container detected for Nextcloud"
echo ">>"

# Init
rm -rf ${CRONTAB_PATH}
mkdir -m 0644 -p ${CRONTAB_PATH}
touch ${CRONTAB_PATH}/nextcloud

# Cron
if [ -n "$PREVIEWGEN_PERIOD" ]; then
  echo "Creating Previews Generator cron task with the following period fields : $PREVIEWGEN_PERIOD"
  echo "${PREVIEWGEN_PERIOD} php -f /var/www/occ preview:pre-generate" >> ${CRONTAB_PATH}/nextcloud
else
  echo "PREVIEWGEN_PERIOD env var empty..."
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
