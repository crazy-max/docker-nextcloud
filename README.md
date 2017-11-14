<p align="center"><a href="https://github.com/crazy-max/docker-nextcloud" target="_blank"><img height="100"src="https://raw.githubusercontent.com/crazy-max/docker-nextcloud/master/res/docker-nextcloud.png"></a></p>

<p align="center">
  <a href="https://microbadger.com/images/crazymax/nextcloud"><img src="https://images.microbadger.com/badges/version/crazymax/nextcloud.svg?style=flat-square" alt="Version"></a>
  <a href="https://travis-ci.org/crazy-max/docker-nextcloud"><img src="https://img.shields.io/travis/crazy-max/docker-nextcloud/master.svg?style=flat-square" alt="Build Status"></a>
  <a href="https://hub.docker.com/r/crazymax/nextcloud/"><img src="https://img.shields.io/docker/stars/crazymax/nextcloud.svg?style=flat-square" alt="Docker Stars"></a>
  <a href="https://hub.docker.com/r/crazymax/nextcloud/"><img src="https://img.shields.io/docker/pulls/crazymax/nextcloud.svg?style=flat-square" alt="Docker Pulls"></a>
  <a href="hhttps://nextcloud.com"><img src="https://img.shields.io/badge/nextcloud-12.0.3-green.svg?style=flat-square" alt="Nextcloud Version"></a>
  <a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=ADCA2SNLJ9FW4"><img src="https://img.shields.io/badge/donate-paypal-7057ff.svg?style=flat-square" alt="Donate Paypal"></a>
</p>

## About

🐳 [Nextcloud](https://nextcloud.com) Docker image based on Nextcloud ☁ stable image with advanced features. More information about the based Nextcloud image on the [official repository](https://github.com/nextcloud/docker).

## Features

### Included

* [SSMTP](https://github.com/alterrebe/docker-mail-relay) for SMTP relay (use PHP as send mode on Nextcloud)
* Cron for Nextcloud background jobs

### From docker-compose

* Reverse proxy with [nginx-proxy](https://github.com/jwilder/nginx-proxy)
* Creation/renewal of Let's Encrypt certificates automatically with [letsencrypt-nginx-proxy-companion](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion)
* [Redis](https://github.com/docker-library/redis) for caching

## Use this image

Download the [docker-compose.yml](docker-compose.yml) template and the [env](env) folder in the same directory.<br />
Edit those files with your preferences, then run :

```bash
$ docker-compose up -d
```

Do not forget to choose **Cron** as background jobs :

![Background jobs](https://raw.githubusercontent.com/crazy-max/docker-nextcloud/master/res/background-jobs.png)

And you can customize the **Email server** settings with your preferences :

![Email server](https://raw.githubusercontent.com/crazy-max/docker-nextcloud/master/res/email-server.png)

## How can i help ?

We welcome all kinds of contributions :raised_hands:!<br />
The most basic way to show your support is to star :star2: the project, or to raise issues :speech_balloon:<br />
Any funds donated will be used to help further development on this project! :gift_heart:

[![Donate Paypal](https://raw.githubusercontent.com/crazy-max/docker-nextcloud/master/res/paypal.png)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=ADCA2SNLJ9FW4)

## License

MIT. See `LICENSE` for more details.
