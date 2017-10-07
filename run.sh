#!/bin/bash

# Nextcloud config
cp -f /assets/nextcloud.config.php /var/www/html/config/docker.config.php

# SSMTP
SSMTP_TPL=/assets/ssmtp.conf
SSMTP_CONF=/etc/ssmtp/ssmtp.conf

if [ -z "$SSMTP_TO" -o -z "$SSMTP_HOST" -o -z "$SSMTP_USER" -o -z "$SSMTP_PASSWORD" ] ; then
    echo "SSMTP_TO, SSMTP_HOST, SSMTP_AUTH_USER and SSMTP_AUTH_PASSWORD must be defined if you want to send emails"
else
    SSMTP_PORT=${SSMTP_PORT:-"25"}
    SSMTP_HOSTNAME=${SSMTP_HOSTNAME:-$(hostname)}
    SSMTP_TLS=${SSMTP_TLS:-"NO"}

    sed -i "s|{{ SSMTP_TO }}|${SSMTP_TO}|g" "$SSMTP_TPL"
    sed -i "s|{{ SSMTP_HOST }}|${SSMTP_HOST}|g" "$SSMTP_TPL"
    sed -i "s|{{ SSMTP_PORT }}|${SSMTP_PORT}|g" "$SSMTP_TPL"
    sed -i "s|{{ SSMTP_HOSTNAME }}|${SSMTP_HOSTNAME}|g" "$SSMTP_TPL"
    sed -i "s|{{ SSMTP_USER }}|${SSMTP_USER}|g" "$SSMTP_TPL"
    sed -i "s|{{ SSMTP_PASSWORD }}|${SSMTP_PASSWORD}|g" "$SSMTP_TPL"
    sed -i "s|{{ SSMTP_TLS }}|${SSMTP_TLS}|g" "$SSMTP_TPL"

    cat "$SSMTP_TPL" > "$SSMTP_CONF"
    echo "sendmail_path=/usr/sbin/ssmtp -t" > /usr/local/etc/php/conf.d/sendmail-ssmtp.ini
fi

# Cron
echo "*/15 * * * * su - www-data -s /bin/bash -c \"php -f /var/www/html/cron.php\" >/proc/1/fd/1 2>/proc/1/fd/2" | crontab -

# Fix perms
chown -R www-data /var/www/html

exec "$@"
