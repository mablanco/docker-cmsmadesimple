FROM php:7.4.4-apache-buster
WORKDIR /var/www/html
RUN apt-get update && \
    apt-get -y install curl zip libzip-dev libgd-dev && \
    apt-get clean
RUN curl -LO http://s3.amazonaws.com/cmsms/downloads/14202/cmsms-2.2.8-install.zip && \
    unzip cmsms-2.2.8-install.zip && \
    rm -r cmsms-2.2.8-install.zip
RUN mv $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini
COPY limits.ini $PHP_INI_DIR/conf.d/
RUN docker-php-ext-install -j$(nproc) mysqli
RUN docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-configure zip && \
    docker-php-ext-install -j$(nproc) zip
RUN docker-php-ext-install -j$(nproc) opcache
RUN a2enmod rewrite
RUN chown -R www-data.www-data .
EXPOSE 80
