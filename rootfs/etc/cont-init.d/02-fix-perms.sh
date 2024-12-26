#!/usr/bin/with-contenv sh
# shellcheck shell=sh

echo "Fixing perms..."
mkdir -p /data \
  /var/run/nginx \
  /var/run/php-fpm
chown nextcloud:nextcloud \
  /data
chown -R nextcloud:nextcloud \
  /home/nextcloud \
  /tpls \
  /var/lib/nginx \
  /var/log/nginx \
  /var/log/php* \
  /var/run/nginx \
  /var/run/php-fpm
