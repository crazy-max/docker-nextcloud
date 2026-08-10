# syntax=docker/dockerfile:1

ARG NEXTCLOUD_VERSION=34.0.2
ARG ALPINE_VERSION=3.24

FROM tianon/gosu:latest AS gosu

FROM --platform=${BUILDPLATFORM:-linux/amd64} crazymax/alpine-s6:${ALPINE_VERSION}-2.2.0.3 AS download
RUN apk --update --no-cache add curl gnupg tar unzip xz
ARG NEXTCLOUD_VERSION
WORKDIR /tmp
RUN curl -SsOL "https://download.nextcloud.com/server/releases/nextcloud-${NEXTCLOUD_VERSION}.tar.bz2" \
  && curl -SsOL "https://download.nextcloud.com/server/releases/nextcloud-${NEXTCLOUD_VERSION}.tar.bz2.asc" \
  && curl -SsOL "https://nextcloud.com/nextcloud.asc"
RUN gpg --import "nextcloud.asc" \
  && gpg --verify --batch --no-tty "nextcloud-${NEXTCLOUD_VERSION}.tar.bz2.asc" "nextcloud-${NEXTCLOUD_VERSION}.tar.bz2"
WORKDIR /dist/nextcloud
RUN tar -xjf "/tmp/nextcloud-${NEXTCLOUD_VERSION}.tar.bz2" --strip 1 -C .

FROM crazymax/alpine-s6:${ALPINE_VERSION}-2.2.0.3
RUN apk --update --no-cache add \
    bash \
    ca-certificates \
    curl \
    ffmpeg \
    ghostscript \
    imagemagick \
    imagemagick-heic \
    imagemagick-pdf \
    imagemagick-svg \
    libxml2 \
    mysql-client \
    mariadb-connector-c \
    nginx \
    openssl \
    php85 \
    php85-bcmath \
    php85-bz2 \
    php85-cli \
    php85-ctype \
    php85-curl \
    php85-dom \
    php85-exif \
    php85-fileinfo \
    php85-fpm \
    php85-ftp \
    php85-gd \
    php85-gmp \
    php85-iconv \
    php85-imap \
    php85-intl \
    php85-json \
    php85-ldap \
    php85-mbstring \
    php85-openssl \
    php85-pcntl \
    php85-pecl-apcu \
    php85-pecl-imagick \
    php85-pecl-memcached \
    php85-pecl-smbclient \
    php85-pdo \
    php85-pdo_mysql \
    php85-pdo_pgsql \
    php85-pdo_sqlite \
    php85-posix \
    php85-redis \
    php85-session \
    php85-simplexml \
    php85-sodium \
    php85-sqlite3 \
    php85-sysvsem \
    php85-xml \
    php85-xmlreader \
    php85-xmlwriter \
    php85-zip \
    php85-zlib \
    postgresql-client \
    tzdata \
    util-linux \
  && mv /etc/php85 /etc/php && ln -s /etc/php /etc/php85 \
  && mv /etc/init.d/php-fpm85 /etc/init.d/php-fpm && ln -s /etc/init.d/php-fpm /etc/init.d/php-fpm85 \
  && mv /etc/logrotate.d/php-fpm85 /etc/logrotate.d/php-fpm && ln -s /etc/logrotate.d/php-fpm /etc/logrotate.d/php-fpm85 \
  && mv /var/log/php85 /var/log/php && ln -s /var/log/php /var/log/php85 \
  && ln -s /usr/sbin/php-fpm85 /usr/sbin/php-fpm \
  && cd /tmp \
  && rm -rf /tmp/* /var/www/*

ENV S6_BEHAVIOUR_IF_STAGE2_FAILS="2" \
  TZ="UTC" \
  PUID="1000" \
  PGID="1000"

COPY --from=gosu /gosu /usr/local/bin/
COPY --from=download --chown=nobody:nogroup /dist/nextcloud /var/www
COPY rootfs /

RUN addgroup -g ${PGID} nextcloud \
  && adduser -D -h /home/nextcloud -u ${PUID} -G nextcloud -s /bin/sh nextcloud

EXPOSE 8000
WORKDIR /var/www
VOLUME [ "/data" ]

ENTRYPOINT [ "/init" ]

HEALTHCHECK --interval=10s --timeout=5s --start-period=20s \
  CMD /usr/local/bin/healthcheck
