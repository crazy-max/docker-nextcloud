#!/usr/bin/with-contenv bash

runas_user() {
  su-exec nextcloud:nextcloud "$@"
}

# From https://github.com/docker-library/mariadb/blob/master/docker-entrypoint.sh#L21-L41
# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
file_env() {
  local var="$1"
  local fileVar="${var}_FILE"
  local def="${2:-}"
  if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
    echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
    exit 1
  fi
  local val="$def"
  if [ "${!var:-}" ]; then
    val="${!var}"
  elif [ "${!fileVar:-}" ]; then
    val="$(< "${!fileVar}")"
  fi
  export "$var"="$val"
  unset "$fileVar"
}

TZ=${TZ:-UTC}
MEMORY_LIMIT=${MEMORY_LIMIT:-512M}
UPLOAD_MAX_SIZE=${UPLOAD_MAX_SIZE:-512M}
CLEAR_ENV=${CLEAR_ENV:-yes}
OPCACHE_MEM_SIZE=${OPCACHE_MEM_SIZE:-128}
LISTEN_IPV6=${LISTEN_IPV6:-true}
APC_SHM_SIZE=${APC_SHM_SIZE:-128M}
REAL_IP_FROM=${REAL_IP_FROM:-0.0.0.0/32}
REAL_IP_HEADER=${REAL_IP_HEADER:-X-Forwarded-For}
LOG_IP_VAR=${LOG_IP_VAR:-remote_addr}

HSTS_HEADER=${HSTS_HEADER:-max-age=15768000; includeSubDomains}
XFRAME_OPTS_HEADER=${XFRAME_OPTS_HEADER:-SAMEORIGIN}
RP_HEADER=${RP_HEADER:-strict-origin}

DB_TYPE=${DB_TYPE:-sqlite}
DB_HOST=${DB_HOST:-db}
DB_NAME=${DB_NAME:-nextcloud}
DB_USER=${DB_USER:-nextcloud}

SIDECAR_CRON=${SIDECAR_CRON:-0}
SIDECAR_NEWSUPDATER=${SIDECAR_NEWSUPDATER:-0}

# Timezone
echo "Setting timezone to ${TZ}..."
ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime
echo ${TZ} > /etc/timezone

# PHP-FPM
echo "Setting PHP-FPM configuration..."
sed -e "s/@MEMORY_LIMIT@/$MEMORY_LIMIT/g" \
  -e "s/@UPLOAD_MAX_SIZE@/$UPLOAD_MAX_SIZE/g" \
  -e "s/@CLEAR_ENV@/$CLEAR_ENV/g" \
  /tpls/etc/php7/php-fpm.d/www.conf > /etc/php7/php-fpm.d/www.conf

# PHP
echo "Setting PHP configuration..."
sed -e "s/@APC_SHM_SIZE@/$APC_SHM_SIZE/g" \
  /tpls/etc/php7/conf.d/apcu.ini > /etc/php7/conf.d/apcu.ini
sed -e "s/@OPCACHE_MEM_SIZE@/$OPCACHE_MEM_SIZE/g" \
  /tpls/etc/php7/conf.d/opcache.ini > /etc/php7/conf.d/opcache.ini
sed -e "s/@MEMORY_LIMIT@/$MEMORY_LIMIT/g" \
  -e "s#@TIMEZONE@#$TZ#g" \
  /tpls/etc/php7/conf.d/override.ini > /etc/php7/conf.d/override.ini

# Nginx
echo "Setting Nginx configuration..."
sed -e "s/@UPLOAD_MAX_SIZE@/$UPLOAD_MAX_SIZE/g" \
  -e "s#@REAL_IP_FROM@#$REAL_IP_FROM#g" \
  -e "s#@REAL_IP_HEADER@#$REAL_IP_HEADER#g" \
  -e "s#@LOG_IP_VAR@#$LOG_IP_VAR#g" \
  -e "s/@HSTS_HEADER@/$HSTS_HEADER/g" \
  -e "s/@XFRAME_OPTS_HEADER@/$XFRAME_OPTS_HEADER/g" \
  -e "s/@RP_HEADER@/$RP_HEADER/g" \
  -e "s#@SUBDIR@#$SUBDIR#g" \
  /tpls/etc/nginx/nginx.conf > /etc/nginx/nginx.conf

if [ "$LISTEN_IPV6" != "true" ]; then
  sed -e '/listen \[::\]:/d' -i /etc/nginx/nginx.conf
fi

# Init Nextcloud
echo "Initializing Nextcloud files/folders..."
mkdir -p /data/config /data/data /data/session /data/tmp /data/userapps
if [ ! -d /data/themes ]; then
  if [ -d /var/www/themes ]; then
    mv -f /var/www/themes /data/
    chown -R nextcloud. /data/themes
  fi
  mkdir -p /data/themes
elif [ -d /var/www/themes ]; then
  rm -rf /var/www/themes
fi
chown nextcloud. /data/config /data/data /data/session /data/tmp /data/userapps /data/themes
ln -sf /data/config/config.php /var/www/config/config.php &>/dev/null
ln -sf /data/themes /var/www/themes &>/dev/null
ln -sf /data/userapps /var/www/userapps &>/dev/null

file_env 'DB_PASSWORD'
if [ -z "$DB_PASSWORD" ]; then
  >&2 echo "ERROR: Either DB_PASSWORD or DB_PASSWORD_FILE must be defined"
  exit 1
fi

# Install Nextcloud if config not found
if [ ! -f /data/config/config.php ]; then
  # https://docs.nextcloud.com/server/stable/admin_manual/configuration_server/automatic_configuration.html
  touch /tmp/first-install
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
  runas_user cat > /data/config/config.php <<EOL
<?php
\$CONFIG = array(
    'datadirectory' => '/data/data',
    'tempdirectory' => '/data/tmp',
    'supportedDatabases' => array(
        'sqlite',
        'mysql',
        'pgsql'
    ),
    'logtimezone' => '${TZ}',
    'logdateformat' => 'Y-m-d H:i:s',
    'memcache.local' => '\\\OC\\\Memcache\\\APCu',
    'apps_paths' => array(
        array(
            'path'=> '/var/www/apps',
            'url' => '/apps',
            'writable' => false,
        ),
        array(
            'path'=> '/data/userapps',
            'url' => '/userapps',
            'writable' => true,
        ),
    ),
    'mail_smtpmode' => 'smtp'
);
EOL
fi
unset DB_USER
unset DB_PASSWORD

# https://docs.nextcloud.com/server/stable/admin_manual/configuration_server/config_sample_php_parameters.html#proxy-configurations
if [ -n "$SUBDIR" ]; then
  cat > /var/www/config/subdir.config.php <<EOL
<?php
\$CONFIG = array(
    'overwritewebroot' => '${SUBDIR}',
);
EOL
fi

# config directory must be writable
chown -R nextcloud. /var/www/config
