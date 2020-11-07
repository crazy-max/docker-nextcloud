#!/usr/bin/with-contenv sh

SIDECAR_CRON=${SIDECAR_CRON:-0}
SIDECAR_PREVIEWGEN=${SIDECAR_PREVIEWGEN:-0}
SIDECAR_NEWSUPDATER=${SIDECAR_NEWSUPDATER:-0}

if [ "$SIDECAR_CRON" = "1" ] || [ "$SIDECAR_PREVIEWGEN" = "1" ] || [ "$SIDECAR_NEWSUPDATER" = "1" ]; then
  exit 0
fi

# Override several config values of Nextcloud
echo "Bootstrapping configuration..."
su-exec nextcloud:nextcloud php -f /tpls/bootstrap.php > /tmp/config.php
su-exec nextcloud:nextcloud cp /tmp/config.php /data/config/config.php
su-exec nextcloud:nextcloud sed -i -e "s#@TZ@#$TZ#g" /data/config/config.php

# Upgrade Nextcloud if installed
if [ "$(occ status --no-ansi | grep 'installed: true')" != "" ]; then
  echo "Upgrading Nextcloud..."
  occ upgrade --no-ansi
fi

# First install ?
if [ -f /tmp/first-install ]; then
  echo "Installing Nextcloud ${NEXTCLOUD_VERSION}..."
  su-exec nextcloud:nextcloud php /var/www/index.php &>/dev/null
  rm -f /tmp/first-install

  echo ">>"
  echo ">> Open your browser to configure your admin account"
  echo ">>"
fi

mkdir -p /etc/services.d/nginx
cat > /etc/services.d/nginx/run <<EOL
#!/usr/bin/execlineb -P
with-contenv
s6-setuidgid ${PUID}:${PGID}
nginx -g "daemon off;"
EOL
chmod +x /etc/services.d/nginx/run

mkdir -p /etc/services.d/php-fpm
cat > /etc/services.d/php-fpm/run <<EOL
#!/usr/bin/execlineb -P
with-contenv
s6-setuidgid ${PUID}:${PGID}
php-fpm7 -F
EOL
chmod +x /etc/services.d/php-fpm/run
