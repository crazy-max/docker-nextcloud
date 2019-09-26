#!/bin/sh

function fixperms() {
  for folder in $@; do
    if $(find ${folder} ! -user nginx -o ! -group nginx | egrep '.' -q); then
      echo "Fixing permissions in $folder..."
      chown -R nginx. "${folder}"
    else
      echo "Permissions already fixed in ${folder}."
    fi
  done
}

function runas_nginx() {
  su - nginx -s /bin/sh -c "$1"
}

MEMORY_LIMIT=${MEMORY_LIMIT:-512M}
UPLOAD_MAX_SIZE=${UPLOAD_MAX_SIZE:-512M}
OPCACHE_MEM_SIZE=${OPCACHE_MEM_SIZE:-128}
APC_SHM_SIZE=${APC_SHM_SIZE:-128M}
REAL_IP_FROM=${REAL_IP_FROM:-0.0.0.0/32}
REAL_IP_HEADER=${REAL_IP_HEADER:-X-Forwarded-For}
LOG_IP_VAR=${LOG_IP_VAR:-remote_addr}

HSTS_HEADER=${HSTS_HEADER:-max-age=15768000; includeSubDomains}
RP_HEADER=${RP_HEADER:-strict-origin}

DB_TYPE=${DB_TYPE:-sqlite}
DB_HOST=${DB_HOST:-db}
DB_NAME=${DB_NAME:-nextcloud}
DB_USER=${DB_USER:-nextcloud}

SIDECAR_CRON=${SIDECAR_CRON:-0}

SIDECAR_NEWSUPDATER=${SIDECAR_NEWSUPDATER:-0}
NC_NEWSUPDATER_THREADS=${NC_NEWSUPDATER_THREADS:-10}
NC_NEWSUPDATER_TIMEOUT=${NC_NEWSUPDATER_TIMEOUT:-300}
NC_NEWSUPDATER_INTERVAL=${NC_NEWSUPDATER_INTERVAL:-900}
NC_NEWSUPDATER_LOGLEVEL=${NC_NEWSUPDATER_LOGLEVEL:-error}

# PHP-FPM
echo "Setting PHP-FPM configuration..."
sed -e "s/@MEMORY_LIMIT@/$MEMORY_LIMIT/g" \
  -e "s/@UPLOAD_MAX_SIZE@/$UPLOAD_MAX_SIZE/g" \
  /tpls/etc/php7/php-fpm.d/www.conf > /etc/php7/php-fpm.d/www.conf

# PHP
echo "Setting PHP configuration..."
sed -e "s/@APC_SHM_SIZE@/$APC_SHM_SIZE/g" \
  /tpls/etc/php7/conf.d/apcu.ini > /etc/php7/conf.d/apcu.ini
sed -e "s/@OPCACHE_MEM_SIZE@/$OPCACHE_MEM_SIZE/g" \
  /tpls/etc/php7/conf.d/opcache.ini > /etc/php7/conf.d/opcache.ini
sed -e "s/@MEMORY_LIMIT@/$MEMORY_LIMIT/g" \
  /tpls/etc/php7/conf.d/override.ini > /etc/php7/conf.d/override.ini

# Nginx
echo "Setting Nginx configuration..."
sed -e "s/@UPLOAD_MAX_SIZE@/$UPLOAD_MAX_SIZE/g" \
  -e "s#@REAL_IP_FROM@#$REAL_IP_FROM#g" \
  -e "s#@REAL_IP_HEADER@#$REAL_IP_HEADER#g" \
  -e "s#@LOG_IP_VAR@#$LOG_IP_VAR#g" \
  -e "s/@HSTS_HEADER@/$HSTS_HEADER/g" \
  -e "s/@RP_HEADER@/$RP_HEADER/g" \
  -e "s#@SUBDIR@#$SUBDIR#g" \
  /tpls/etc/nginx/nginx.conf > /etc/nginx/nginx.conf

# Init Nextcloud
echo "Initializing Nextcloud files / folders..."
mkdir -p /data/config /data/data /data/session /data/tmp /data/userapps /etc/supervisord /var/log/supervisord
if [ ! -d /data/themes ]; then
  if [ -d /var/www/themes ]; then
    mv -f /var/www/themes /data/
  fi
  mkdir -p /data/themes
elif [ -d /var/www/themes ]; then
  rm -rf /var/www/themes
fi
ln -sf /data/config/config.php /var/www/config/config.php &>/dev/null
ln -sf /data/themes /var/www/themes &>/dev/null
ln -sf /data/userapps /var/www/userapps &>/dev/null

if [[ -z "$DB_PASSWORD" ]]; then
  >&2 echo "ERROR: DB_PASSWORD must be defined"
  exit 1
fi

# Install Nextcloud if config not found
firstInstall=0
if [ ! -f /data/config/config.php ]; then
  # https://docs.nextcloud.com/server/stable/admin_manual/configuration_server/automatic_configuration.html
  firstInstall=1
  echo "Creating automatic configuration..."
  cat > /var/www/config/autoconfig.php <<EOL
<?php
\$AUTOCONFIG = array(
    'directory' => '/data/data',
    'dbtype' => '${DB_TYPE}',
    'dbname' => '${DB_NAME}',
    'dbuser' => '${DB_USER}',
    'dbpass' => '${DB_PASSWORD}',
    'dbhost' => '${DB_HOST}',
    'dbtableprefix' => '',
);
EOL
  sed -e "s#@TZ@#$TZ#g" /tpls/data/config/config.php > /data/config/config.php
  chown nginx. /data/config/config.php /var/www/config/autoconfig.php
fi
unset DB_USER
unset DB_PASSWORD

# https://docs.nextcloud.com/server/stable/admin_manual/configuration_server/config_sample_php_parameters.html#proxy-configurations
if [ ! -z "$SUBDIR" ]; then
  cat > /var/www/config/subdir.config.php <<EOL
<?php
\$CONFIG = array(
    'overwritewebroot' => '${SUBDIR}',
);
EOL
  chown nginx. /var/www/config/subdir.config.php
fi

# Sidecar Nextcloud news updater container
if [ "$SIDECAR_NEWSUPDATER" = "1" ]; then
  echo ">>"
  echo ">> Sidecar news updater container detected for Nextcloud"
  echo ">>"

  # Init
  rm /etc/supervisord/cron.conf /etc/supervisord/nginx.conf /etc/supervisord/php.conf

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
  chown nginx. /etc/news_updater.ini
# Sidecar cron container
elif [ "$SIDECAR_CRON" = "1" ]; then
  echo ">>"
  echo ">> Sidecar cron container detected for Nextcloud"
  echo ">>"

  # Init
  rm /etc/supervisord/news_updater.conf /etc/supervisord/nginx.conf /etc/supervisord/php.conf
  rm -rf ${CRONTAB_PATH}
  mkdir -m 0644 -p ${CRONTAB_PATH}
  touch ${CRONTAB_PATH}/nginx

  # Cron
  if [ ! -z "$CRON_PERIOD" ]; then
    echo "Creating Nextcloud cron task with the following period fields : $CRON_PERIOD"
    echo "${CRON_PERIOD} php -f /var/www/cron.php" >> ${CRONTAB_PATH}/nginx
  else
    echo "CRON_PERIOD env var empty..."
  fi

  # Fix perms
  echo "Fixing permissions..."
  chmod -R 0644 ${CRONTAB_PATH}
else
  # Init
  rm /etc/supervisord/cron.conf /etc/supervisord/news_updater.conf

  # Override several config values of Nextcloud
  echo "Bootstrapping configuration..."
  runas_nginx "php -f /tpls/bootstrap.php" > /tmp/config.php
  mv /tmp/config.php /data/config/config.php
  sed -i -e "s#@TZ@#$TZ#g" /data/config/config.php

  echo "Fixing permissions..."
  fixperms /data/config /data/data /data/session /data/themes /data/tmp /data/userapps

  # Upgrade Nextcloud if installed
  if [ "$(occ status --no-ansi | grep 'installed: true')" != "" ]; then
    echo "Upgrading Nextcloud..."
    occ upgrade --no-ansi
  fi

  # First install ?
  if [ ${firstInstall} -eq 1 ]; then
    echo "Installing Nextcloud ${NEXTCLOUD_VERSION}..."
    runas_nginx "cd /var/www && php index.php &>/dev/null"

    echo ">>"
    echo ">> Open your browser to configure your admin account"
    echo ">>"
  fi
fi

exec "$@"
