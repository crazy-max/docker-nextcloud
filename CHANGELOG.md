# Changelog

## 15.0.2-RC2 / 14.0.6-RC2 / 13.0.10-RC2 / 12.0.13-RC4 (2019/01/31)

* Alpine Linux 3.9

## 15.0.2-RC1 / 14.0.6-RC1 / 13.0.10-RC1 (2019/01/11)

* Upgrade to Nextcloud 13.0.10, 14.0.6 and 15.0.2

## 15.0.1-RC2 / 14.0.5-RC2 (2019/01/10)

* Enable gzip but do not remove ETag headers
* Remove X-Powered-By, which is an information leak
* Missing delivery of `.woff2` files

## 15.0.1-RC1 / 14.0.5-RC1 / 13.0.9-RC1 / 12.0.13-RC3 (2019/01/10)

* Upgrade to Nextcloud 13.0.9, 14.0.5 and 15.0.1
* Bind to unprivileged port : `8000`

## 15.0.0-RC2 / 14.0.4-RC2 / 13.0.8-RC2 / 12.0.13-RC2 (2018/12/30)

* Add `SUBDIR` env var (Issue #7)
* Add rewrite rules for user_webfinger and Social app
* Use `--batch` for gpg (see https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=913614)

## 15.0.0-RC1 (2018/12/10)

* Upgrade to Nextcloud 15.0.0

## 14.0.4-RC1 / 13.0.8-RC1 / 12.0.13-RC1 (2018/11/22)

* Upgrade to Nextcloud 12.0.13, 13.0.8 and 14.0.4

## 14.0.3-RC1 (2018/11/13)

* Upgrade to Nextcloud 14.0.3

## 14.0.2-RC1 / 13.0.7-RC1 / 12.0.12-RC1 (2018/10/11)

* Upgrade to Nextcloud 12.0.12, 13.0.7 and 14.0.2

## 14.0.1-RC1 (2018/09/25)

* Upgrade to Nextcloud 14.0.1

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

* Upgrade to Nextcloud 12.0.11

## 13.0.6-RC1 (2018/08/30)

* Upgrade to Nextcloud 13.0.6
* Unset sensitive environment variables

## 13.0.5-RC1 / 12.0.10-RC1 (2018/07/23)

* Upgrade to Nextcloud 12.0.10 and 13.0.5
* Alpine Linux 3.8
* PHP 7.2

## 13.0.4-RC1 / 12.0.9-RC1 (2018/06/11)

* Upgrade to Nextcloud 12.0.9 and 13.0.4

## 13.0.3-RC1 / 12.0.8-RC1 (2018/06/07)

* Upgrade to Nextcloud 12.0.8 and 13.0.3

## 13.0.2-RC1 / 12.0.7-RC1 (2018/04/27)

* Upgrade to Nextcloud 12.0.7 and 13.0.2

## 13.0.1-RC1 / 12.0.6-RC1 (2018/03/16)

* Upgrade to Nextcloud 12.0.6 and 13.0.1
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

* Upgrade to Nextcloud 12.0.5

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
