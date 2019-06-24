FROM alpine:3.10

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL maintainer="CrazyMax" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.name="nextcloud" \
  org.label-schema.description="Nextcloud" \
  org.label-schema.version=$VERSION \
  org.label-schema.url="https://github.com/crazy-max/docker-nextcloud" \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url="https://github.com/crazy-max/docker-nextcloud" \
  org.label-schema.vendor="CrazyMax" \
  org.label-schema.schema-version="1.0"

ENV NEXTCLOUD_VERSION="16.0.1" \
  CRONTAB_PATH="/var/spool/cron/crontabs"

RUN apk --update --no-cache add \
    ca-certificates \
    ffmpeg \
    libressl \
    libsmbclient \
    libxml2 \
    nginx \
    php7 \
    php7-apcu \
    php7-bz2 \
    php7-cli \
    php7-ctype \
    php7-curl \
    php7-dom \
    php7-exif \
    php7-fileinfo \
    php7-fpm \
    php7-ftp \
    php7-gd \
    php7-gmp \
    php7-iconv \
    php7-imagick \
    php7-intl \
    php7-json \
    php7-ldap \
    php7-mbstring \
    php7-mcrypt \
    php7-memcached \
    php7-opcache \
    php7-openssl \
    php7-pcntl \
    php7-pdo \
    php7-pdo_mysql \
    php7-pdo_pgsql \
    php7-pdo_sqlite \
    php7-posix \
    php7-redis \
    php7-session \
    php7-simplexml \
    php7-sqlite3 \
    php7-xml \
    php7-xmlreader \
    php7-xmlwriter \
    php7-zip \
    php7-zlib \
    python3 \
    su-exec \
    supervisor \
    tzdata \
  && apk --update --no-cache add -t build-dependencies \
    autoconf \
    automake \
    build-base \
    gnupg \
    libtool \
    pcre-dev \
    php7-dev \
    php7-pear \
    samba-dev \
    tar \
    wget \
  && pip3 install --upgrade pip \
  && pip3 install nextcloud_news_updater --install-option="--install-scripts=/usr/bin" \
  && rm -rf /var/www/* /tmp/* \
  && cd /tmp \
  && wget -q https://pecl.php.net/get/smbclient-1.0.0.tgz \
  && pecl install smbclient-1.0.0.tgz \
  && wget -q https://download.nextcloud.com/server/releases/nextcloud-${NEXTCLOUD_VERSION}.tar.bz2 \
  && wget -q https://download.nextcloud.com/server/releases/nextcloud-${NEXTCLOUD_VERSION}.tar.bz2.asc \
  && wget -q https://nextcloud.com/nextcloud.asc \
  && gpg --import nextcloud.asc \
  && gpg --verify --batch --no-tty nextcloud-${NEXTCLOUD_VERSION}.tar.bz2.asc nextcloud-${NEXTCLOUD_VERSION}.tar.bz2 \
  && tar -xjf nextcloud-${NEXTCLOUD_VERSION}.tar.bz2 --strip 1 -C /var/www \
  && rm -f nextcloud-${NEXTCLOUD_VERSION}.tar* nextcloud.asc \
  && chown -R nginx. /var/lib/nginx /var/log/nginx /var/log/php7 /var/tmp/nginx /var/www \
  && apk del build-dependencies \
  && rm -rf /root/.gnupg /tmp/* /var/cache/apk/* /var/www/updater

COPY entrypoint.sh /entrypoint.sh
COPY assets /

RUN chmod a+x /entrypoint.sh /usr/local/bin/* \
  && chown -R nginx. /tpls/data /tpls/bootstrap.php

EXPOSE 8000
WORKDIR /var/www
VOLUME [ "/data" ]

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/usr/bin/supervisord", "-c", "/etc/supervisord.conf" ]
