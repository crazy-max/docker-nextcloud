#!/usr/bin/with-contenv sh

echo "Fixing perms..."
chown nextcloud. \
  /data
chown -R nextcloud. \
  /tpls \
  /var/lib/nginx \
  /var/log/nginx \
  /var/log/php7 \
  /var/run/nginx \
  /var/run/php-fpm \
  /var/tmp/nginx
