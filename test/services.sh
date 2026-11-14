#!/bin/sh
set -eu

if [ "${SIDECAR_CRON:-0}" = "1" ] || [ "${SIDECAR_PREVIEWGEN:-0}" = "1" ]; then
  services=cron
  disabled="nginx php-fpm"
else
  services="nginx php-fpm"
  disabled=cron
fi

for service in $services; do
  s6-svwait -u -t 30000 "/run/service/$service"
  test "$(s6-svstat -o up,wantedup /run/service/"$service")" = "true true"
  if [ "$service" != "cron" ]; then
    pid=$(s6-svstat -o pid /run/service/"$service")
    grep -Eq "^Uid:[[:space:]]+${PUID}[[:space:]]" "/proc/${pid}/status"
    grep -Eq "^Gid:[[:space:]]+${PGID}[[:space:]]" "/proc/${pid}/status"
  fi
done
for service in $disabled; do
  test "$(s6-svstat -o up,wantedup /run/service/"$service")" = "false false"
done

/usr/local/bin/healthcheck
