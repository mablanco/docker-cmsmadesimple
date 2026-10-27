FROM php:8.3.36-apache-trixie@sha256:0d46cb96775228313d3997c155f78227de13bf9972e0c736e653fb23aded79b2
ARG DEBIAN_FRONTEND=noninteractive
ARG CMSMADESIMPLE_VERSION=2.2.24
ARG DOWNLOAD_SUBFOLDER=15484
ARG CMSMADESIMPLE_SHA256=2804810f2d78e020cf96221b96b4d38cb3f2d24ad6e5ebb1afec1eed77854621
WORKDIR /var/www/html
COPY limits.ini $PHP_INI_DIR/conf.d/
# Build the PHP extensions, then keep only the runtime libraries they link to
RUN set -eux; \
    savedAptMark="$(apt-mark showmanual)"; \
    apt-get update; \
    apt-get -y upgrade; \
    apt-get -y install --no-install-recommends \
        libfreetype-dev \
        libicu-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libwebp-dev \
        libzip-dev \
        unzip; \
    docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp; \
    docker-php-ext-install -j"$(nproc)" gd intl mysqli opcache zip; \
    curl -fsSL -o cmsms.zip \
        "https://s3.amazonaws.com/cmsms-forge/downloads/${DOWNLOAD_SUBFOLDER}/cmsms-${CMSMADESIMPLE_VERSION}-install.zip"; \
    echo "${CMSMADESIMPLE_SHA256}  cmsms.zip" | sha256sum -c -; \
    unzip cmsms.zip; \
    rm cmsms.zip; \
    apt-mark auto '.*' > /dev/null; \
    apt-mark manual $savedAptMark; \
    ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
        | awk '/=>/ { so = $(NF-1); if (index(so, "/usr/local/") == 1) { next }; gsub("^/(usr/)?", "", so); printf "*%s\n", so }' \
        | sort -u \
        | xargs -r dpkg-query --search \
        | cut -d: -f1 \
        | sort -u \
        | xargs -r apt-mark manual; \
    apt-get -y purge --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    rm -rf /var/lib/apt/lists/*; \
    mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"; \
    a2enmod rewrite; \
    chown -R www-data:www-data .
EXPOSE 80
