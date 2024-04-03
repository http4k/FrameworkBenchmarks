FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -yqq && apt-get install -yqq software-properties-common > /dev/null
RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php > /dev/null && \
    apt-get update -yqq > /dev/null && apt-get upgrade -yqq > /dev/null

RUN apt-get install -yqq nginx git unzip \
    php8.3-cli php8.3-mysql php8.3-mbstring php8.3-xml php8.3-dev > /dev/null

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

RUN apt-get install -y php-pear php8.3-dev libevent-dev > /dev/null
RUN pecl install event-3.0.8 > /dev/null && echo "extension=event.so" > /etc/php/8.3/cli/conf.d/event.ini

ADD ./ /lumen
WORKDIR /lumen

RUN composer install --optimize-autoloader --classmap-authoritative --no-dev --quiet
RUN composer require joanhey/adapterman:^0.6 --quiet

RUN mkdir -p /lumen/storage
RUN mkdir -p /lumen/storage/framework/sessions
RUN mkdir -p /lumen/storage/framework/views
RUN mkdir -p /lumen/storage/framework/cache

RUN chmod -R 777 /lumen

EXPOSE 8080

CMD php -c deploy/conf/cli-php.ini \
    server-man.php start
