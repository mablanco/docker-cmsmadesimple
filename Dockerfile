FROM php:8.3-rc-apache-buster
ENV DEBIAN_FRONTEND noninteractive
ARG CMSMADESIMPLE_VERSION=2.2.21
WORKDIR /var/www/html
RUN apt-get update && \
    apt-get -y install curl zip libzip-dev libgd-dev && \
    apt-get -yq autoremove && \
    apt-get clean && \
    rm -rf /var/lib/{apt,dpkg,cache,log}
COPY limits.ini $PHP_INI_DIR/conf.d/
RUN curl -s -LO http://s3.amazonaws.com/cmsms/downloads/15179/cmsms-$CMSMADESIMPLE_VERSION-install.zip && \
    unzip cmsms-$CMSMADESIMPLE_VERSION-install.zip && \
    rm -r cmsms-$CMSMADESIMPLE_VERSION-install.zip && \
    mv $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini && \
    docker-php-ext-configure zip && \
    docker-php-ext-install -j$(nproc) gd opcache mysqli zip && \
    a2enmod rewrite && \
    chown -R www-data.www-data .
EXPOSE 4444
