#!/usr/bin/with-contenv sh
# shellcheck shell=sh

if [ -n "${PGID}" ] && [ "${PGID}" != "$(id -g nextcloud)" ]; then
  echo "Switching to PGID ${PGID}..."
  sed -i -e "s/^nextcloud:\([^:]*\):[0-9]*/nextcloud:\1:${PGID}/" /etc/group
  sed -i -e "s/^nextcloud:\([^:]*\):\([0-9]*\):[0-9]*/nextcloud:\1:\2:${PGID}/" /etc/passwd
fi
if [ -n "${PUID}" ] && [ "${PUID}" != "$(id -u nextcloud)" ]; then
  echo "Switching to PUID ${PUID}..."
  sed -i -e "s/^nextcloud:\([^:]*\):[0-9]*:\([0-9]*\)/nextcloud:\1:${PUID}:\2/" /etc/passwd
fi
