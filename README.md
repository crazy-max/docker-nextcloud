<p align="center"><a href="https://github.com/crazy-max/docker-nextcloud" target="_blank"><img height="100"src="https://raw.githubusercontent.com/crazy-max/docker-nextcloud/master/.res/docker-nextcloud.png"></a></p>

<p align="center">
  <a href="https://microbadger.com/images/crazymax/nextcloud"><img src="https://images.microbadger.com/badges/version/crazymax/nextcloud.svg?style=flat-square" alt="Version"></a>
  <a href="https://travis-ci.org/crazy-max/docker-nextcloud"><img src="https://img.shields.io/travis/crazy-max/docker-nextcloud/master.svg?style=flat-square" alt="Build Status"></a>
  <a href="https://hub.docker.com/r/crazymax/nextcloud/"><img src="https://img.shields.io/docker/stars/crazymax/nextcloud.svg?style=flat-square" alt="Docker Stars"></a>
  <a href="https://hub.docker.com/r/crazymax/nextcloud/"><img src="https://img.shields.io/docker/pulls/crazymax/nextcloud.svg?style=flat-square" alt="Docker Pulls"></a>
  <a href="https://quay.io/repository/crazymax/nextcloud"><img src="https://quay.io/repository/crazymax/nextcloud/status?style=flat-square" alt="Docker Repository on Quay"></a>
  <a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=ADCA2SNLJ9FW4"><img src="https://img.shields.io/badge/donate-paypal-7057ff.svg?style=flat-square" alt="Donate Paypal"></a>
</p>

## About

🐳 [Nextcloud](https://nextcloud.com) Docker image based on Alpine Linux and Nginx with advanced features.<br />
If you are interested, [check out](https://hub.docker.com/r/crazymax/) my other 🐳 Docker images!

## Features

### Included

* Alpine Linux 3.7, Nginx, PHP 7.1
* Tarball authenticity checked during building process
* Data, config, user apps and themes persistence in the same folder
* [Automatic installation](https://docs.nextcloud.com/server/12/admin_manual/configuration_server/automatic_configuration.html)
* Cron task for [Nextcloud background jobs]((https://docs.nextcloud.com/server/12/admin_manual/configuration_server/background_jobs_configuration.html#cron))
* [SSMTP](https://linux.die.net/man/8/ssmtp) for SMTP relay (use PHP as send mode on Nextcloud)
* OPCache enabled to store precompiled script bytecode in shared memory
* APCu installed and configured
* Memcached and Redis also enabled to enhance server performance
* Database connectors MySQL/MariaDB, PostgreSQL and SQLite3 enabled
* Exif, IMAP, LDAP, FTP, GMP, SMB enabled (required for specific apps)
* FFmpeg, iconv, Imagick installed for preview generation

### From docker-compose

* Reverse proxy with [nginx-proxy](https://github.com/jwilder/nginx-proxy)
* Creation/renewal of Let's Encrypt certificates automatically with [letsencrypt-nginx-proxy-companion](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion)
* [Redis](https://github.com/docker-library/redis) for caching
* [MariaDB](https://github.com/docker-library/mariadb) as database instance

## Docker

### Environment variables

* `UID` : Nextcloud user id (default to `1000`)
* `GID` : Nextcloud group id (default to `1000`)
* `TZ` : The timezone assigned to the container (default to `UTC`)
* `SITE_DOMAIN` : Your primary domain used during first installation (default to `localhost`)
* `CRON_PERIOD` : Periodically execute Nextcloud [cron](https://docs.nextcloud.com/server/12/admin_manual/configuration_server/background_jobs_configuration.html#cron) (disabled if empty ; ex `*/15 * * * *`)
* `MEMORY_LIMIT` : PHP memory limit (default to `256M`)
* `UPLOAD_MAX_SIZE` : Upload max size (default to `512M`)
* `OPCACHE_MEM_SIZE` : PHP OpCache memory consumption (default to `128`)
* `APC_SHM_SIZE` : APCu memory size (default to `128M`)
* `HSTS_HEADER` : [HTTP Strict Transport Security](https://docs.nextcloud.com/server/12/admin_manual/configuration_server/harden_server.html#enable-http-strict-transport-security) header value (default to `max-age=15768000; includeSubDomains`)
* `DB_TYPE` : Database type (mysql, pgsql or sqlite) (default to `sqlite`)
* `DB_NAME` : Database name (default to `nextcloud`)
* `DB_USER` : Username for database (default to `nextcloud`)
* `DB_PASSWORD` : Password for database user (default to `asupersecretpassword`)
* `DB_HOST` : Database host (default to `db`)
* `SSMTP_HOST` : SMTP server host
* `SSMTP_PORT` : SMTP server port (default to `25`)
* `SSMTP_HOSTNAME` : Full hostname (default to `$(hostname -f)`)
* `SSMTP_USER` : SMTP username
* `SSMTP_PASSWORD` : SMTP password
* `SSMTP_TLS` : SSL/TLS (default to `NO`)

### Volumes

* `/data` : Contains config, data folders, installed user apps (not core ones), session, themes, tmp folders

### Ports

* `80` : HTTP port

## Use this image

Docker compose is the recommended way to run this image. You can use the following [docker compose template](docker-compose.yml). Edit this file with your preferences, then run :

```bash
docker-compose up -d
docker-compose logs -f
```

Or use the following minimal command :

```bash
docker run -d -p 80:80 --name nextcloud \
  -e UID=1000 \
  -e GID=1000 \
  -e TZ="Europe/Paris" \
  -e SITE_DOMAIN="matomo.example.com" \
  -v $(pwd)/data:/data \
  crazymax/nextcloud:latest
```

## Notes

### First installation

If you run the container for the first time, the installation will be automatic using the `SITE_DOMAIN` and `DB_*` environment variables.<br />
Then open your browser to `http://${SITE_DOMAIN}` to configure your admin account.

### OCC command

If you want to use the [occ command](https://docs.nextcloud.com/server/12/admin_manual/configuration_server/occ_command.html) to perform common server operations like manage users, encryption, passwords, LDAP setting, and more, type :

```bash
docker exec -ti nextcloud occ
```

### Cron

Do not forget to choose **Cron** as background jobs :

![Background jobs](.res/background-jobs.png)

### Email

And you can customize the **Email server** settings with your preferences :

![Email server](.res/email-server.png)

### Redis cache

Redis is recommended, alongside APCu to make Nextcloud more faster.
If you want to enable Redis, deploy a redis container (see [docker-compose.yml](docker-compose.yml)) and add this to your `config.php` :

```
    'memcache.local' => '\OC\Memcache\APCu',
    'memcache.distributed' => '\OC\Memcache\Redis',
    'memcache.locking' => '\OC\Memcache\Redis',
    'redis' => array(
        'host' => 'redis',
        'port' => 6379,
    ),
```

## Upgrade

To upgrade to the latest version of Nextcloud, pull the newer image and launch the container. Nextcloud will upgrade automatically :

```bash
docker-compose pull
docker-compose up -d
```

## How can i help ?

We welcome all kinds of contributions :raised_hands:!<br />
The most basic way to show your support is to star :star2: the project, or to raise issues :speech_balloon:<br />
Any funds donated will be used to help further development on this project! :gift_heart:

[![Donate Paypal](.res/paypal.png)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=ADCA2SNLJ9FW4)

## License

MIT. See `LICENSE` for more details.
