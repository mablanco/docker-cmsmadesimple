FROM php:8.3.13-apache
ARG DEBIAN_FRONTEND=noninteractive
ARG CMSMADESIMPLE_VERSION=2.2.21
ARG DOWNLOAD_SUBFOLDER=15179
WORKDIR /var/www/html
COPY limits.ini $PHP_INI_DIR/conf.d/
RUN apt-get update && \
    apt-get -y install curl zip libzip4 libzip-dev libgd3 libgd-dev libicu72 libicu-dev && \
    curl -s -LO http://s3.amazonaws.com/cmsms/downloads/$DOWNLOAD_SUBFOLDER/cmsms-$CMSMADESIMPLE_VERSION-install.zip && \
    unzip cmsms-$CMSMADESIMPLE_VERSION-install.zip && \
    rm -r cmsms-$CMSMADESIMPLE_VERSION-install.zip && \
    mv $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini && \
    docker-php-ext-install -j$(nproc) gd intl opcache mysqli zip && \
    a2enmod rewrite && \
    chown -R www-data.www-data . && \
    apt-get -yq purge libzip-dev libgd-dev libicu-dev && \
    apt-get -yq autoremove && \
    apt-get clean && \
    rm -rf /var/lib/{apt,dpkg,cache,log}
EXPOSE 80
