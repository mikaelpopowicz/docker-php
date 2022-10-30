# docker-php

PHP docker image based on php:apache-bullseye.

## Basic usage

```dockerfile
ARG PHP_VERSION=8.1

FROM mpopowicz/php:${PHP_VERSION}-apache as base

# install dependencies, nodejs, etc.
# configure dev configurations (e.g opcache)

FROM base

WORKDIR /var/www/html
# copy application code, skipping files based on .dockerignore
COPY . /var/www/html

RUN composer install --optimize-autoloader --no-dev \
    && mkdir -p /var/www/html/storage/logs \
    && php artisan optimize:clear \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage 

# configure production configurations (e.g opcache)
```

## Included PHP ini

```ini
log_errors = On
error_log = ${APACHE_LOG_DIR}/error.log
upload_max_filesize = 16M
post_max_size = 16M
date.timezone = Europe/Paris
```

## Available PHP modules

* bcmath
* Core
* ctype
* curl
* date
* dom
* fileinfo
* filter
* ftp
* gd
* hash
* iconv
* intl
* json
* libxml
* mbstring
* mongodb
* mysqlnd
* opcache
* openssl
* pcntl
* pcre
* PDO
* pdo_mysql
* pdo_pgsql
* pdo_sqlite
* Phar
* posix
* readline
* redis
* Reflection
* session
* SimpleXML
* soap
* sodium
* SPL
* sqlite3
* standard
* tokenizer
* xml
* xmlreader
* xmlwriter
* Zend OPcache
* zip
* zlib

## Install Nodejs

```dockerfile
ARG NODE_VERSION=19
ARG PHP_VERSION=8.1

FROM mpopowicz/php:${PHP_VERSION}-apache

ARG NODE_VERSION

RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | sudo -E bash - \
    && apt-get update \
    && apt-get install -y --no-install-recommends nodejs

RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*
```

## Install Puppeteer & Chromium

```dockerfile
ARG PHP_VERSION=8.1

FROM mpopowicz/php:${PHP_VERSION}-apache

ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_VERSION=18.1.0

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        chromium fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf libxss1

RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* 

# Nodejs is required
RUN npm config set update-notifier false && \
    npm puppeteer@v${PUPPETEER_VERSION} --unsafe-perm=true --allow-root
```
