#!/bin/bash

# Timezone
ln -snf /usr/share/zoneinfo/${TZ:-"UTC"} /etc/localtime
echo ${TZ:-"UTC"} > /etc/timezone

# SSMTP
if [ -z "$SSMTP_HOST" -o -z "$SSMTP_USER" -o -z "$SSMTP_PASSWORD" ] ; then
  echo "SSMTP_HOST, SSMTP_AUTH_USER and SSMTP_AUTH_PASSWORD must be defined if you want to send emails"
fi

cat > "/etc/ssmtp/ssmtp.conf" <<EOL
#
# Config file for sSMTP sendmail
#
# The person who gets all mail for userids < 1000
# Make this empty to disable rewriting.
#root=

# The place where the mail goes. The actual machine name is required no
# MX records are consulted. Commonly mailhosts are named mail.domain.com
mailhub=${SSMTP_HOST}:${SSMTP_PORT:-"25"}

# Where will the mail seem to come from?
#rewriteDomain=

# The full hostname
hostname=${SSMTP_HOSTNAME:-"$(hostname -f)"}

# Are users allowed to set their own From: address?
# YES - Allow the user to specify their own From: address
# NO - Use the system generated From: address
FromLineOverride=YES

# Auth
AuthUser=${SSMTP_USER}
AuthPass=${SSMTP_PASSWORD}

# SSL/TLS
UseTLS=${SSMTP_TLS:-"NO"}
UseSTARTTLS=${SSMTP_TLS:-"NO"}
EOL

echo "sendmail_path=/usr/sbin/ssmtp -t" > /usr/local/etc/php/conf.d/sendmail-ssmtp.ini

exec "$@"
