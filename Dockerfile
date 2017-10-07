FROM nextcloud:12.0.3
MAINTAINER Cr@zy <webmaster@crazyws.fr>

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        cron \
        ssmtp \
        mailutils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ADD assets/ /assets

COPY run.sh /
ENTRYPOINT ["/entrypoint.sh", "/bin/bash", "/run.sh"]