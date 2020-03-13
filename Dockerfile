FROM php:7.4-apache

EXPOSE 80
ENV APACHE_DOCUMENT_ROOT /app

# install dependencies
RUN apt update \
 && apt install -y git cron libzip-dev dumb-init \
 && apt-get autoremove -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && docker-php-ext-install zip mysqli pdo_mysql

ARG VERSION=1.3.7

RUN git clone https://github.com/Newcomer1989/TSN-Ranksystem.git /app \
 && cd ${APACHE_DOCUMENT_ROOT} \
 && git fetch --all --tags --prune \
 && git checkout tags/${VERSION} \
 && rm -R .git .github \
 && mv /app/other /app/other.default \
 && mkdir -p /cronjob \
 && sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf \
 && sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

VOLUME ["/app/other","/app/logs"]
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["bash", "-c", "/entrypoint.sh"]
WORKDIR /app

ADD src/crontab /etc/crontab
ADD src/cronjob.sh /cronjob/
ADD src/entrypoint.sh /

