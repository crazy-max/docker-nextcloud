#!/bin/sh

crond -s ${CRONTAB_PATH} \
  -L /dev/stdout \
  -f &

wait
