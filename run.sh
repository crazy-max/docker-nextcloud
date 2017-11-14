#!/bin/bash

# Timezone
ln -snf /usr/share/zoneinfo/${TZ:-"UTC"} /etc/localtime
echo ${TZ:-"UTC"} > /etc/timezone

# SSMTP
SSMTP_TPL=/assets/ssmtp.conf
SSMTP_CONF=/etc/ssmtp/ssmtp.conf

SSMTP_PORT=${SSMTP_PORT:-"25"}
SSMTP_TLS=${SSMTP_TLS:-"NO"}

if [ -z "$SSMTP_ROOT" -o -z "$SSMTP_HOST" -o -z "$SSMTP_USER" -o -z "$SSMTP_PASSWORD" ] ; then
    echo "SSMTP_ROOT, SSMTP_HOST, SSMTP_AUTH_USER and SSMTP_AUTH_PASSWORD must be defined if you want to send emails"
fi

sed -i "s|{{ SSMTP_ROOT }}|${SSMTP_ROOT}|g" "$SSMTP_TPL"
sed -i "s|{{ SSMTP_HOST }}|${SSMTP_HOST}|g" "$SSMTP_TPL"
sed -i "s|{{ SSMTP_PORT }}|${SSMTP_PORT}|g" "$SSMTP_TPL"
sed -i "s|{{ SSMTP_USER }}|${SSMTP_USER}|g" "$SSMTP_TPL"
sed -i "s|{{ SSMTP_PASSWORD }}|${SSMTP_PASSWORD}|g" "$SSMTP_TPL"
sed -i "s|{{ SSMTP_TLS }}|${SSMTP_TLS}|g" "$SSMTP_TPL"

cat "$SSMTP_TPL" > "$SSMTP_CONF"
echo "sendmail_path=/usr/sbin/ssmtp -t" > /usr/local/etc/php/conf.d/sendmail-ssmtp.ini

# Nextcloud config
NEXTCLOUD_TPL=/assets/nextcloud.config.php
NEXTCLOUD_CONF=/var/www/html/config/docker.config.php

MYSQL_DATABASE=${MYSQL_DATABASE:-"nextcloud"}
MYSQL_USER=${MYSQL_USER:-"nextcloud"}

sed -i "s|{{ MYSQL_DATABASE }}|${MYSQL_DATABASE}|g" "$NEXTCLOUD_TPL"
sed -i "s|{{ MYSQL_USER }}|${MYSQL_USER}|g" "$NEXTCLOUD_TPL"
sed -i "s|{{ MYSQL_PASSWORD }}|${MYSQL_PASSWORD}|g" "$NEXTCLOUD_TPL"

cat "$NEXTCLOUD_TPL" > "$NEXTCLOUD_CONF"

# Nextcloud cron
echo "*/15 * * * * su - www-data -s /bin/bash -c \"php -f /var/www/html/cron.php\" >/proc/1/fd/1 2>/proc/1/fd/2" | crontab -

# Fix perms
chown -R www-data /var/www/html

exec "$@"
