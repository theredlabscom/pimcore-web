FROM php:7.3-apache
LABEL version="1.0"
LABEL description="This container allows developers to install pimcore 5.x easily."
LABEL maintainer="erojas@coreshopsolutions.com"

# Filesystem preparation
COPY ./php-overrides.ini /usr/local/etc/php/php.ini
RUN mkdir -p /usr/share/man/man1

# Modify default Apache configuration
ENV APACHE_DOCUMENT_ROOT /pimcore/web
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
RUN a2enmod rewrite

# Install Operating System Dependencies
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y \
        libfontconfig1 \
        libxrender1 \
        libmcrypt-dev \
        default-jre \
        openssl \
        libc-client-dev \
        libxml2-dev \
        cron

RUN apt-get install -y \
        xfonts-75dpi \
        libfreetype6 libfreetype6-dev \
        libjpeg62-turbo libjpeg62-turbo-dev \
        libpng-dev \
        zlib1g zlib1g-dev \
        libicu-dev \
        libkrb5-dev \
        g++ \
        curl libcurl4-gnutls-dev \
        unzip libbz2-dev libzip-dev \
        libxslt-dev

RUN apt-get install -y apt-utils \
        imagemagick inkscape pngnq pngcrush xvfb cabextract \
        poppler-utils xz-utils libreoffice libreoffice-math jpegoptim ffmpeg \
        html2text ghostscript exiftool wkhtmltopdf \
        libmagickwand-dev graphviz

# # Configure, install and enable php exntesions
# RUN docker-php-ext-install -j$(nproc) iconv
# RUN docker-php-ext-install mbstring
# RUN docker-php-ext-install curl
# RUN docker-php-ext-install xml
# RUN docker-php-ext-install dom
# RUN docker-php-ext-install simplexml
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pdo pdo_mysql
RUN docker-php-ext-install zip
RUN docker-php-ext-install bz2
RUN docker-php-ext-install intl
RUN docker-php-ext-install soap
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install opcache
RUN docker-php-ext-install exif
RUN docker-php-ext-install xsl

RUN docker-php-ext-configure gd \
	--with-freetype-dir=/usr/include/ \
	--with-jpeg-dir=/usr/include/ \
	--with-png-dir=/usr/include
RUN docker-php-ext-install -j$(nproc) gd

RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap

RUN pecl install redis \
    && pecl install xdebug \
    && pecl install mcrypt-1.0.2 \
    && docker-php-ext-enable redis xdebug mcrypt

RUN pecl install imagick && docker-php-ext-enable imagick

# Install Composer
RUN mkdir /var/www/.composer && chown www-data:www-data /var/www/.composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install prestissimo
USER www-data
RUN composer global require hirak/prestissimo
USER root

# Install maintenance cronjob
RUN mkdir -p /var/spool/cron/crontabs && chown root:crontab /var/spool/cron/crontabs
COPY cronjobs /var/spool/cron/crontabs/www-data
RUN chown www-data:crontab /var/spool/cron/crontabs/www-data
RUN chmod 0600 /var/spool/cron/crontabs/www-data

# Free disk space
RUN rm -rf /var/lib/apt/lists/*
# RUN rm /pimcore/.placeholder
# RUN chown www-data:www-data /pimcore

# USER www-data
# RUN cd /pimcore; COMPOSER_MEMORY_LIMIT=-1 composer create-project pimcore/skeleton .
