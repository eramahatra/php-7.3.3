FROM php:7.3.3-apache

RUN apt-get update && \
	apt-get install -y cron gnumeric libxml2 libxml2-dev libpng-dev zlib1g-dev libzip-dev openssl libssl-dev libcurl4-openssl-dev wget iputils-ping
RUN pecl install mongodb
RUN docker-php-ext-configure mbstring --enable-mbstring
RUN echo "extension=mongodb.so" > /usr/local/etc/php/conf.d/mongo.ini

RUN docker-php-ext-install pdo pdo_mysql mbstring xml zip gd
RUN a2enmod rewrite
RUN mkdir -p /var/www/html/storage & mkdir /var/www/html/public

COPY apache2.conf /etc/apache2/apache2.conf
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
COPY php7.ini /usr/local/etc/php/conf.d/php.ini
COPY index.html /var/www/html/public/

RUN chmod 0777 -R /var/www/html/storage

RUN php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin --filename=composer \
    && chmod +x /usr/local/bin/composer

WORKDIR /var/www/html
