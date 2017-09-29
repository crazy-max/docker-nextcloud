FROM nextcloud:12.0.3
MAINTAINER Cr@zy <webmaster@crazyws.fr>

COPY docker-nextcloud.config.php /var/www/html/config/docker-nextcloud.config.php