#!/bin/sh

su-exec ${USERNAME} php -f /var/www/occ "$@"
