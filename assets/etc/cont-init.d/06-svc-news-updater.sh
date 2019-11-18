#!/usr/bin/with-contenv sh

SIDECAR_NEWSUPDATER=${SIDECAR_NEWSUPDATER:-0}
NC_NEWSUPDATER_THREADS=${NC_NEWSUPDATER_THREADS:-10}
NC_NEWSUPDATER_TIMEOUT=${NC_NEWSUPDATER_TIMEOUT:-300}
NC_NEWSUPDATER_INTERVAL=${NC_NEWSUPDATER_INTERVAL:-900}
NC_NEWSUPDATER_LOGLEVEL=${NC_NEWSUPDATER_LOGLEVEL:-error}

# Continue only if sidecar news updater container
if [ "$SIDECAR_NEWSUPDATER" != "1" ]; then
  exit 0
fi

echo ">>"
echo ">> Sidecar news updater container detected for Nextcloud"
echo ">>"

# Nextcloud News Updater config file (https://github.com/nextcloud/news-updater#usage)
cat > /etc/news_updater.ini <<EOL
[updater]
threads = ${NC_NEWSUPDATER_THREADS}
timeout = ${NC_NEWSUPDATER_TIMEOUT}
interval = ${NC_NEWSUPDATER_INTERVAL}
loglevel = ${NC_NEWSUPDATER_LOGLEVEL}
url = /var/www
mode = endless
EOL

# Create service
mkdir -p /etc/services.d/news-updater
cat > /etc/services.d/news-updater/run <<EOL
#!/usr/bin/execlineb -P
with-contenv
s6-setuidgid ${PUID}:${PGID}
/usr/bin/nextcloud-news-updater -c /etc/news_updater.ini
EOL
chmod +x /etc/services.d/news-updater/run
