#!/usr/bin/with-contenv sh

echo "Fixing perms..."
mkdir -p /data \
  /var/run/nginx \
  /var/run/php-fpm
chown nextcloud. \
  /data
chown -R nextcloud. \
  /home/nextcloud \
  /tpls \
  /var/lib/nginx \
  /var/log/nginx \
  /var/log/php7 \
  /var/run/nginx \
  /var/run/php-fpm
