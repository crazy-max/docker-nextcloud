#!/usr/bin/with-contenv bash
# shellcheck shell=bash

runas_user() {
  gosu nextcloud:nextcloud "$@"
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
    val="$(<"${!fileVar}")"
  fi
  export "$var"="$val"
  unset "$fileVar"
}

persist_web_dir() {
  local web_path="$1"
  local data_path="$2"
  local entry_name
  local web_entry

  if [ -d "$web_path" ] && [ ! -L "$web_path" ]; then
    for web_entry in "$web_path"/* "$web_path"/.[!.]*; do
      [ -e "$web_entry" ] || continue
      entry_name="$(basename "$web_entry")"
      [ -e "${data_path}/${entry_name}" ] || cp -a "$web_entry" "$data_path/"
    done
    mv "$web_path" "${web_path}.dist"
  fi
  if [ -e "$web_path" ] && [ ! -L "$web_path" ]; then
    echo >&2 "ERROR: Failed to replace ${web_path} with ${data_path} symlink"
    exit 1
  fi
}

TZ=${TZ:-UTC}
MEMORY_LIMIT=${MEMORY_LIMIT:-512M}
UPLOAD_MAX_SIZE=${UPLOAD_MAX_SIZE:-512M}
PM_MAX_CHILDREN=${PM_MAX_CHILDREN:-20}
BODY_TIMEOUT=${BODY_TIMEOUT:-300s}
CLEAR_ENV=${CLEAR_ENV:-yes}
OPCACHE_MEM_SIZE=${OPCACHE_MEM_SIZE:-128}
LISTEN_IPV6=${LISTEN_IPV6:-true}
APC_SHM_SIZE=${APC_SHM_SIZE:-128M}
REAL_IP_FROM=${REAL_IP_FROM:-0.0.0.0/32}
REAL_IP_HEADER=${REAL_IP_HEADER:-X-Forwarded-For}
LOG_IP_VAR=${LOG_IP_VAR:-remote_addr}
if [ -z "$SUBDIR" ]
then
  REDIRECT_URL='$scheme://$host'
else
  REDIRECT_URL=$SUBDIR
fi

HSTS_HEADER=${HSTS_HEADER:-max-age=15768000; includeSubDomains}
XFRAME_OPTS_HEADER=${XFRAME_OPTS_HEADER:-SAMEORIGIN}
RP_HEADER=${RP_HEADER:-strict-origin}

DB_TYPE=${DB_TYPE:-sqlite}
DB_HOST=${DB_HOST:-db}
DB_NAME=${DB_NAME:-nextcloud}
DB_USER=${DB_USER:-nextcloud}
DB_TIMEOUT=${DB_TIMEOUT:-60}

SIDECAR_CRON=${SIDECAR_CRON:-0}
SIDECAR_NEWSUPDATER=${SIDECAR_NEWSUPDATER:-0}

# Timezone
echo "Setting timezone to ${TZ}..."
ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime
echo ${TZ} >/etc/timezone

# PHP-FPM
echo "Setting PHP-FPM configuration..."
sed -e "s/@MEMORY_LIMIT@/$MEMORY_LIMIT/g" \
  -e "s/@UPLOAD_MAX_SIZE@/$UPLOAD_MAX_SIZE/g" \
  -e "s/@CLEAR_ENV@/$CLEAR_ENV/g" \
  -e "s/@PM_MAX_CHILDREN@/$PM_MAX_CHILDREN/g" \
  /tpls/etc/php/php-fpm.d/www.conf >/etc/php/php-fpm.d/www.conf

# PHP
echo "Setting PHP configuration..."
sed -e "s/@APC_SHM_SIZE@/$APC_SHM_SIZE/g" \
  /tpls/etc/php/conf.d/apcu.ini >/etc/php/conf.d/apcu.ini
sed -e "s/@OPCACHE_MEM_SIZE@/$OPCACHE_MEM_SIZE/g" \
  /tpls/etc/php/conf.d/opcache.ini >/etc/php/conf.d/opcache.ini
sed -e "s/@MEMORY_LIMIT@/$MEMORY_LIMIT/g" \
  -e "s#@TIMEZONE@#$TZ#g" \
  /tpls/etc/php/conf.d/override.ini >/etc/php/conf.d/override.ini

# Nginx
echo "Setting Nginx configuration..."
sed -e "s/@UPLOAD_MAX_SIZE@/$UPLOAD_MAX_SIZE/g" \
  -e "s/@BODY_TIMEOUT@/$BODY_TIMEOUT/g" \
  -e "s#@REAL_IP_FROM@#$REAL_IP_FROM#g" \
  -e "s#@REAL_IP_HEADER@#$REAL_IP_HEADER#g" \
  -e "s#@LOG_IP_VAR@#$LOG_IP_VAR#g" \
  -e "s/@HSTS_HEADER@/$HSTS_HEADER/g" \
  -e "s/@XFRAME_OPTS_HEADER@/$XFRAME_OPTS_HEADER/g" \
  -e "s/@RP_HEADER@/$RP_HEADER/g" \
  -e "s#@REDIRECT_URL@#$REDIRECT_URL#g" \
  /tpls/etc/nginx/nginx.conf >/etc/nginx/nginx.conf

if [ "$LISTEN_IPV6" != "true" ]; then
  sed -e '/listen \[::\]:/d' -i /etc/nginx/nginx.conf
fi

# Init Nextcloud
echo "Initializing Nextcloud files/folders..."
mkdir -p /data/config /data/data /data/session /data/themes /data/tmp /data/userapps

persist_web_dir /var/www/config /data/config
persist_web_dir /var/www/themes /data/themes
persist_web_dir /var/www/userapps /data/userapps

# FIXME: Drop this migration cleanup after existing volumes have been recreated
# with ln -sfn and no longer contain legacy nested self-links.
[ "$(readlink /data/config/config 2>/dev/null)" = "/data/config" ] && rm -f /data/config/config
[ "$(readlink /data/themes/themes 2>/dev/null)" = "/data/themes" ] && rm -f /data/themes/themes
[ "$(readlink /data/userapps/userapps 2>/dev/null)" = "/data/userapps" ] && rm -f /data/userapps/userapps

ln -sfn /data/config /var/www/config
ln -sfn /data/themes /var/www/themes
ln -sfn /data/userapps /var/www/userapps
chown nextcloud:nextcloud /data/config /data/data /data/session /data/tmp /data/userapps /data/themes

# Check DB
file_env 'DB_USER'
file_env 'DB_PASSWORD'

if [ "$DB_TYPE" = "mysql" ]; then
  echo "Checking mysql database connection..."
  if [ -z "$DB_HOST" ]; then
    echo >&2 "ERROR: DB_HOST must be defined"
    exit 1
  fi
  if [ -z "$DB_PASSWORD" ]; then
    echo >&2 "ERROR: Either DB_PASSWORD or DB_PASSWORD_FILE must be defined"
    exit 1
  fi

  dbcmd="mariadb -h ${DB_HOST} -u "${DB_USER}" "-p${DB_PASSWORD}""

  echo "Waiting ${DB_TIMEOUT}s for database to be ready..."
  counter=1
  while ! ${dbcmd} -e "show databases;" >/dev/null 2>&1; do
    sleep 1
    counter=$((counter + 1))
    if [ ${counter} -gt ${DB_TIMEOUT} ]; then
      echo >&2 "ERROR: Failed to connect to database on $DB_HOST"
      exit 1
    fi
  done
  echo "Database ready!"
  unset dbcmd
fi

if [ "$DB_TYPE" = "pgsql" ]; then
  echo "Checking pgsql database connection..."
  if [ -z "$DB_HOST" ]; then
    echo >&2 "ERROR: DB_HOST must be defined"
    exit 1
  fi
  if [ -z "$DB_PASSWORD" ]; then
    echo >&2 "ERROR: Either DB_PASSWORD or DB_PASSWORD_FILE must be defined"
    exit 1
  fi

  export PGPASSWORD=${DB_PASSWORD}
  dbcmd="psql --host=${DB_HOST} --username=${DB_USER} -lqt"

  echo "Waiting ${DB_TIMEOUT}s for database to be ready..."
  counter=1
  while ${dbcmd} | cut -d \| -f 1 | grep -qw "${DB_NAME}" > /dev/null 2>&1; [ $? -ne 0 ]; do
    sleep 1
    counter=$((counter + 1))
    if [ ${counter} -gt ${DB_TIMEOUT} ]; then
      echo >&2 "ERROR: Failed to connect to database on $DB_HOST"
      exit 1
    fi
  done
  echo "Database ready!"
  unset dbcmd PGPASSWORD
fi

# Install Nextcloud if config not found
if [ ! -f /data/config/config.php ]; then
  # https://docs.nextcloud.com/server/stable/admin_manual/configuration_server/automatic_configuration.html
  touch /tmp/first-install
  echo "Creating automatic configuration..."
  cat >/var/www/config/autoconfig.php <<EOL
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
  runas_user cat >/data/config/config.php <<EOL
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

subdir_config="/var/www/config/docker-subdir.config.php"
# https://docs.nextcloud.com/server/stable/admin_manual/configuration_server/config_sample_php_parameters.html#proxy-configurations
if [ -n "$SUBDIR" ]; then
  cat >"${subdir_config}" <<EOL
<?php
// Generated by docker-nextcloud from the SUBDIR environment variable.
\$CONFIG = array(
    'overwritewebroot' => '${SUBDIR}',
);
EOL
else
  rm -f "${subdir_config}"
fi

# config, themes and user apps directories must be writable
chown -R nextcloud:nextcloud /data/config /data/themes /data/userapps
