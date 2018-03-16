# Changelog

## 13.0.1-RC1 / 12.0.6-RC1 (2018/03/16)

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
