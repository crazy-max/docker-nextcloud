FROM nextcloud:12.0.4
MAINTAINER CrazyMax <crazy-max@users.noreply.github.com>

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.name="nextcloud" \
  org.label-schema.description="Nextcloud stable image with advanced features" \
  org.label-schema.version=$VERSION \
  org.label-schema.url="https://github.com/crazy-max/docker-nextcloud" \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url="https://github.com/crazy-max/docker-nextcloud" \
  org.label-schema.vendor="CrazyMax" \
  org.label-schema.schema-version="1.0"

RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    cron \
    ssmtp \
    supervisor \
    mailutils \
    tzdata \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY assets/ /
COPY config/ /usr/src/nextcloud/config/
COPY init.sh /

RUN mkdir /var/log/supervisord /var/run/supervisord \
  && echo "*/15 * * * * su - www-data -s /bin/bash -c \"php -f /var/www/html/cron.php\""| crontab -

ENTRYPOINT ["/entrypoint.sh", "/bin/bash", "/init.sh"]
CMD ["/usr/bin/supervisord"]