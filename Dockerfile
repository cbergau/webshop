FROM php:7-apache

RUN apt-get -yqq update \
    && apt-get install -yqq wget \
    && wget -O - https://download.newrelic.com/548C16BF.gpg | apt-key add - \
    && sh -c 'echo "deb http://apt.newrelic.com/debian/ newrelic non-free" > /etc/apt/sources.list.d/newrelic.list' \
    && apt-get -yqq update \
    && apt-get -yqq install \
        newrelic-php5 \
        git \
        unzip \
    && newrelic-install install \
    && docker-php-ext-install mysqli opcache

# OPCache
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

# XDebug
RUN pecl install xdebug
RUN echo "zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20151012/xdebug.so" >> /usr/local/etc/php/conf.d/php.ini
RUN touch /usr/local/etc/php/conf.d/xdebug.ini; \
	echo xdebug.remote_enable=1 >> /usr/local/etc/php/conf.d/xdebug.ini; \
  	echo xdebug.remote_autostart=0 >> /usr/local/etc/php/conf.d/xdebug.ini; \
  	echo xdebug.remote_connect_back=1 >> /usr/local/etc/php/conf.d/xdebug.ini; \
  	echo xdebug.remote_port=9000 >> /usr/local/etc/php/conf.d/xdebug.ini; \
  	echo xdebug.remote_log=/tmp/php5-xdebug.log >> /usr/local/etc/php/conf.d/xdebug.ini;

# New Relic configuration
RUN echo "newrelic.license=f7d5ff979f36d064f017a684cc4c4b1f9123156e" >> /usr/local/etc/php/conf.d/newrelic.ini

COPY . /var/www/html

# Symfony cache
RUN usermod -u 1000 www-data
RUN chown -R www-data:www-data /var/www/html/var
