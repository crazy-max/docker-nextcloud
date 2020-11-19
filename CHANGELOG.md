# Changelog

## 20.0.2-RC1 / 19.0.5-RC1 / 18.0.11-RC1 (2020/11/19)

* Nextcloud 18.0.11, 19.0.5, 20.0.2

## 20.0.1-RC2 / 19.0.4-RC3 / 18.0.10-RC3 / 17.0.10-RC3 (2020/11/07)

* Dedicated sidecar container for previews generator

## 20.0.1-RC1 / 19.0.4-RC2 / 18.0.10-RC2 / 17.0.10-RC2 (2020/11/01)

* Nextcloud 20.0.1
* Handle pre-generation of previews through [Preview Generator](https://github.com/rullzer/previewgenerator) plugin
* Update cron period example
* Add env var to clear environment in FPM workers
* Publish image to GHCR

## 20.0.0-RC1 / 19.0.4-RC1 / 18.0.10-RC1 / 17.0.10-RC1 (2020/10/08)

* Nextcloud 17.0.10, 18.0.10, 19.0.4, 20.0.0

## 19.0.3-RC1 / 18.0.9-RC1 (2020/09/10)

* Nextcloud 18.0.9, 19.0.3

## 19.0.2-RC1 / 18.0.8-RC1 / 17.0.9-RC1 (2020/08/28)

* Nextcloud 17.0.9, 18.0.8, 19.0.2

## 19.0.1-RC2 / 18.0.7-RC2 / 17.0.8-RC2 (2020/08/09)

* Now based on [Alpine Linux with s6 overlay](https://github.com/crazy-max/docker-alpine-s6/)

## 19.0.1-RC1 / 18.0.7-RC1 / 17.0.8-RC1 (2020/07/16)

* Nextcloud 17.0.8, 18.0.7, 19.0.1

## 19.0.0-RC2 / 18.0.6-RC1 / 17.0.7-RC2 / 16.0.11-RC2 (2020/06/20)

* Nextcloud 18.0.6
* Fix missing `bcmath` PHP module

## 18.0.5-RC1 / 17.0.7-RC1 / 16.0.11-RC1 (2020/06/04)

* Nextcloud 16.0.11, 17.0.7, 18.0.5

## 19.0.0-RC1 (2020/06/03)

* Nextcloud 19.0.0
* Alpine Linux 3.12

## 18.0.4-RC4 / 17.0.6-RC4 / 16.0.10-RC4 (2020/05/29)

* Multi-platform Docker image

## 18.0.4-RC3 / 17.0.6-RC3 / 16.0.10-RC3 (2020/05/17)

* Add `LISTEN_IPV6` env var

## 18.0.4-RC2 / 17.0.6-RC2 / 16.0.10-RC2 (2020/04/25)

* Update Nginx configuration
* Remove EOL versions

## 18.0.4-RC1 / 17.0.6-RC1 / 16.0.10-RC1 (2020/04/23)

* Nextcloud 16.0.10, 17.0.6, 18.0.4

## 18.0.3-RC2 / 17.0.5-RC2 / 16.0.9-RC2 (2020/03/27)

* Fix folder creation

## 18.0.3-RC1 / 17.0.5-RC1 (2020/03/21)

* Nextcloud 17.0.5, 18.0.3

## 18.0.2-RC1 / 17.0.4-RC1 / 16.0.9-RC1 (2020/03/12)

* Nextcloud 16.0.9, 17.0.4, 18.0.2

## 18.0.1-RC1 (2020/02/12)

* Nextcloud 18.0.1

## 18.0.0-RC2 / 17.0.3-RC2 / 16.0.8-RC2 (2020/02/10)

* Fix bad substitution (#31)

## 17.0.3-RC1 / 16.0.8-RC1 (2020/01/30)

* Nextcloud 16.0.8, 17.0.3

## 18.0.0-RC1 (2020/01/23)

* Nextcloud 18.0.0
* Alpine Linux 3.11

## 17.0.2-RC2 / 16.0.7-RC2 / 15.0.14-RC2 (2020/01/22)

* Move Nginx temp folders to `/tmp` (#30)

## 17.0.2-RC1 / 16.0.7-RC1 / 15.0.14-RC1 (2019/12/19)

* Nextcloud 15.0.14, 16.0.7, 17.0.2

## 17.0.1-RC5 / 16.0.6-RC5 / 15.0.13-RC5 (2019/12/18)

* Add imagemagick libraries for many image formats

## 17.0.1-RC4 / 16.0.6-RC4 / 15.0.13-RC4 (2019/12/07)

* Fix timezone

## 17.0.1-RC3 / 16.0.6-RC3 / 15.0.13-RC3 (2019/11/18)

* :warning: Run as non-root user (#6)
* Allow to set custom `PUID`/`PGID`
* Switch to [s6-overlay](https://github.com/just-containers/s6-overlay/) as process supervisor
* Allow to use Docker secrets for `DB_PASSWORD`
* Prevent exposing Nginx and PHP version
* Remove php-fpm access log (already mirrored by nginx)

> :warning: **UPGRADE NOTES**
> As the Docker container now runs as a non-root user, you have to first stop the container and change permissions to `data` volume:
> ```
> docker-compose stop
> chown -R ${PUID}:${PGID} data/
> docker-compose pull
> docker-compose up -d
> ```

## 17.0.1-RC2 / 16.0.6-RC2 / 15.0.13-RC2 (2019/11/11)

* Add `XFRAME_OPTS_HEADER` environment variable

## 17.0.1-RC1 / 16.0.6-RC1 / 15.0.13-RC1 (2019/11/11)

* Nextcloud 15.0.13, 16.0.6, 17.0.1

## 17.0.0-RC4 / 16.0.5-RC4 / 15.0.12-RC4 / 14.0.14-RC3 (2019/10/26)

* Base image update

## 17.0.0-RC3 / 16.0.5-RC3 / 15.0.12-RC3 / 14.0.14-RC2 (2019/10/25)

* Fix CVE-2019-11043

## 17.0.0-RC2 / 16.0.5-RC2 / 15.0.12-RC2 (2019/09/26)

* Switch to GitHub Actions
* :warning: Stop publishing Docker image on Quay

## 17.0.0-RC1 / 16.0.5-RC1 / 15.0.12-RC1 (2019/09/26)

* Nextcloud 15.0.12, 16.0.5, 17.0.0
* Implicit timezone through tzdata package
* Cache bcmap files

## 16.0.4-RC1 / 15.0.11-RC1 / 14.0.14-RC1 (2019/08/14)

* Nextcloud 14.0.14, 15.0.11, 16.0.4

## 16.0.3-RC2 / 15.0.10-RC2 / 14.0.13-RC2 (2019/07/09)

* Add healthcheck
* Remove php-fpm access log (already mirrored by nginx)

## 16.0.3-RC1 / 15.0.10-RC1 (2019/07/09)

* Nextcloud 15.0.10, 16.0.3

## 14.0.13-RC1 (2019/07/08)

* Nextcloud 14.0.13

## 16.0.2-RC1 / 15.0.9-RC1 (2019/07/04)

* Nextcloud 15.0.9, 16.0.2

## 16.0.1-RC2 / 15.0.8-RC2 / 14.0.12-RC2 (2019/06/24)

* Alpine Linux 3.10 for Nextcloud 15 and 16
* Cache `map` files

## 16.0.1-RC1 / 15.0.8-RC1 / 14.0.12-RC1 / 14.0.11-RC1 (2019/05/18)

* Nextcloud 14.0.11, 14.0.12, 15.0.8, 16.0.1

## 16.0.0-RC2 / 15.0.7-RC4 / 14.0.10-RC4 / 13.0.12-RC5 / 12.0.13-RC9 (2019/04/28)

* Add `large_client_header_buffers` Nginx config

## 16.0.0-RC1 (2019/04/24)

* Nextcloud 16.0.0

## 16.0.0RC2-RC1 / 15.0.7-RC3 / 14.0.10-RC3 / 13.0.12-RC4 / 12.0.13-RC8 (2019/04/22)

* Nextcloud 16.0.0RC2
* Bind IPv6

## 16.0.0RC1-RC1 / 15.0.7-RC2 / 14.0.10-RC2 / 13.0.12-RC3 / 12.0.13-RC7 (2019/04/13)

* Nextcloud 16.0.0RC1 (not pushed to latest)
* Add `REAL_IP_FROM`, `REAL_IP_HEADER` and `LOG_IP_VAR` environment variables

## 14.0.9-RC1 / 14.0.10-RC1 (2019/04/10)

* Nextcloud 14.0.9, 14.0.10

## 15.0.7-RC1 (2019/04/09)

* Nextcloud 15.0.7

## 15.0.6-RC1 (2019/04/04)

* Nextcloud 15.0.6

## 12.0.13-RC6 (2019/03/17)

* Fix PHP incompatibility with Nextcloud 12 (not compatible with > PHP 7.2)

## 15.0.5-RC2 / 14.0.8-RC2 / 13.0.12-RC2 / 12.0.13-RC5 (2019/03/17)

* Handle [Nextcloud News Updater](https://github.com/nextcloud/news-updater) for [News plugin](https://apps.nextcloud.com/apps/news) through a sidecar container
* Sidecar cron is now enabled through the `SIDECAR_CRON` env var

> :warning: **UPGRADE NOTES**
> Sidecar cron container is now handled with `SIDECAR_CRON` environment variable.
> See docker-compose example and README for more info.

## 15.0.5-RC1 / 14.0.8-RC1 / 13.0.12-RC1 (2019/02/27)

* Nextcloud 13.0.12, 14.0.8 and 15.0.5
* Add exception for ocm-provider

## 15.0.4-RC1 / 14.0.7-RC1 / 13.0.11-RC1 (2019/02/08)

* Nextcloud 13.0.11, 14.0.7 and 15.0.4

## 15.0.2-RC2 / 14.0.6-RC2 / 13.0.10-RC2 / 12.0.13-RC4 (2019/01/31)

* Alpine Linux 3.9

## 15.0.2-RC1 / 14.0.6-RC1 / 13.0.10-RC1 (2019/01/11)

* Nextcloud 13.0.10, 14.0.6 and 15.0.2

## 15.0.1-RC2 / 14.0.5-RC2 (2019/01/10)

* Enable gzip but do not remove ETag headers
* Remove X-Powered-By, which is an information leak
* Missing delivery of `.woff2` files

## 15.0.1-RC1 / 14.0.5-RC1 / 13.0.9-RC1 / 12.0.13-RC3 (2019/01/10)

* Nextcloud 13.0.9, 14.0.5 and 15.0.1
* Bind to unprivileged port : `8000`

## 15.0.0-RC2 / 14.0.4-RC2 / 13.0.8-RC2 / 12.0.13-RC2 (2018/12/30)

* Add `SUBDIR` env var (Issue #7)
* Add rewrite rules for user_webfinger and Social app
* Use `--batch` for gpg (see https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=913614)

## 15.0.0-RC1 (2018/12/10)

* Nextcloud 15.0.0

## 14.0.4-RC1 / 13.0.8-RC1 / 12.0.13-RC1 (2018/11/22)

* Nextcloud 12.0.13, 13.0.8 and 14.0.4

## 14.0.3-RC1 (2018/11/13)

* Nextcloud 14.0.3

## 14.0.2-RC1 / 13.0.7-RC1 / 12.0.12-RC1 (2018/10/11)

* Nextcloud 12.0.12, 13.0.7 and 14.0.2

## 14.0.1-RC1 (2018/09/25)

* Nextcloud 14.0.1

## 14.0.0-RC2 / 13.0.6-RC3 / 12.0.11-RC3 (2018/09/06)

* Add Referrer-Policy header through `RP_HEADER` environment variable ([nextcloud/server#9122](https://github.com/nextcloud/server/issues/9122))
* Unset sensitive environment variables

## 14.0.0-RC1 / 13.0.6-RC2 / 12.0.11-RC2 (2018/09/06)

* Add Nextcloud 14.0.0
* Set PHP memory limit to PHP CLI
* Recommended PHP memory limit is 512MB
* Remove SSMTP
* Built in php mailer is no longer supported (default mode to smtp)

## 12.0.11-RC1 (2018/08/31)

* Nextcloud 12.0.11

## 13.0.6-RC1 (2018/08/30)

* Nextcloud 13.0.6
* Unset sensitive environment variables

## 13.0.5-RC1 / 12.0.10-RC1 (2018/07/23)

* Nextcloud 12.0.10 and 13.0.5
* Alpine Linux 3.8
* PHP 7.2

## 13.0.4-RC1 / 12.0.9-RC1 (2018/06/11)

* Nextcloud 12.0.9 and 13.0.4

## 13.0.3-RC1 / 12.0.8-RC1 (2018/06/07)

* Nextcloud 12.0.8 and 13.0.3

## 13.0.2-RC1 / 12.0.7-RC1 (2018/04/27)

* Nextcloud 12.0.7 and 13.0.2

## 13.0.1-RC1 / 12.0.6-RC1 (2018/03/16)

* Nextcloud 12.0.6 and 13.0.1
* Remove ability to set a custom UID / GID (performance issue with overlay driver)

## 13.0.0-RC3 / 12.0.5-RC4 (2018/02/28)

* Fix permission on themes folder
* Review check on first install

## 13.0.0-RC2 / 12.0.5-RC3 (2018/02/27)

* Permissions fix more efficient
* Cron now only available as a "sidecar" container (see docker-compose)
* Use busybox cron
* Replace Nginx + Let's Encrypt with Traefik (see docker-compose)
* Disable auto restart and retries of "supervisored" programs (Docker Way)
* Rename UID and GID env vars to PUID and PGID
* Remove SITE_DOMAIN env var

## 13.0.0-RC1 (2018/02/07)

* Add Nextcloud 13.0.0

## 12.0.5-RC2 (2018/02/05)

* Based on Alpine Linux 3.7 and Nginx
* Redirect Nginx and PHP-FPM to stdout
* Ability to set a custom UID / GID
* Remove env file
* Automatic installation on first launch
* Tarball authenticity checked during building process
* Data, config, user apps and themes persistence in the same folder
* Cron task disabled by default
* OPCache enabled to store precompiled script bytecode in shared memory
* APCu installed and configured
* Memcached and Redis also enabled to enhance server performance
* Database connectors MySQL/MariaDB, PostgreSQL and SQLite3 enabled
* Exif, IMAP, LDAP, FTP, GMP, SMB enabled (required for specific apps)
* FFmpeg, iconv, Imagick installed for preview generation
* Ability to customize HTTP Strict Transport Security header value
* Add occ wrapper
* Bootstrap config
* Log timezone set for Nextcloud
* Publish image to Quay

## 12.0.5-RC1 (2018/01/25)

* Nextcloud 12.0.5

## 12.0.4-RC5 (2018/01/09)

* Base image updated

## 12.0.4-RC4 (2018/01/07)

* Base image updated

## 12.0.4-RC3 (2018/01/04)

* Base image updated

## 12.0.4-RC2 (2017/12/09)

* Split Nextcloud config
* Use [Supervisor](http://supervisord.org/) to control process
* Fix cron issue

## 12.0.4-RC1 (2017/12/07)

* Easiest nextcloud config

## 12.0.3-RC3 (2017/12/06)

* Push Docker image through TravisCI

## 12.0.3-RC2 (2017/10/07)

* Review SSMTP and Nextcloud config
* CMD apache2-foreground
* Mutu letsencrypt and proxy env

## 12.0.3-RC1 (2017/09/29)

* Initial version
