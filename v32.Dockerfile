# syntax=docker/dockerfile:1

ARG NEXTCLOUD_VERSION=32.0.7
ARG ALPINE_VERSION=3.23

FROM crazymax/yasu:latest AS yasu
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
    php84 \
    php84-bcmath \
    php84-bz2 \
    php84-cli \
    php84-ctype \
    php84-curl \
    php84-dom \
    php84-exif \
    php84-fileinfo \
    php84-fpm \
    php84-ftp \
    php84-gd \
    php84-gmp \
    php84-iconv \
    php84-imap \
    php84-intl \
    php84-json \
    php84-ldap \
    php84-mbstring \
    php84-opcache \
    php84-openssl \
    php84-pcntl \
    php84-pecl-apcu \
    php84-pecl-imagick \
    php84-pecl-memcached \
    php84-pecl-smbclient \
    php84-pdo \
    php84-pdo_mysql \
    php84-pdo_pgsql \
    php84-pdo_sqlite \
    php84-posix \
    php84-redis \
    php84-session \
    php84-simplexml \
    php84-sodium \
    php84-sqlite3 \
    php84-sysvsem \
    php84-xml \
    php84-xmlreader \
    php84-xmlwriter \
    php84-zip \
    php84-zlib \
    postgresql-client \
    python3 \
    py3-pip \
    tzdata \
    util-linux \
  && mv /etc/php84 /etc/php && ln -s /etc/php /etc/php84 \
  && mv /etc/init.d/php-fpm84 /etc/init.d/php-fpm && ln -s /etc/init.d/php-fpm /etc/init.d/php-fpm84 \
  && mv /etc/logrotate.d/php-fpm84 /etc/logrotate.d/php-fpm && ln -s /etc/logrotate.d/php-fpm /etc/logrotate.d/php-fpm84 \
  && mv /var/log/php84 /var/log/php && ln -s /var/log/php /var/log/php84 \
  && ln -s /usr/sbin/php-fpm84 /usr/sbin/php-fpm \
  && pip3 install --upgrade --break-system-packages pip \
  && pip3 install --break-system-packages nextcloud_news_updater \
  && cd /tmp \
  && rm -rf /tmp/* /var/www/*

ENV S6_BEHAVIOUR_IF_STAGE2_FAILS="2" \
  TZ="UTC" \
  PUID="1000" \
  PGID="1000"

COPY --from=yasu / /
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
