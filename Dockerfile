FROM nextcloud:12.0.3
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
    mailutils \
    tzdata \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ADD assets/ /assets
ADD run.sh /

RUN chmod a+x /run.sh

ENTRYPOINT ["/entrypoint.sh", "/bin/bash", "/run.sh"]
CMD ["apache2-foreground"]