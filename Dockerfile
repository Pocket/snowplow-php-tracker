FROM php:7.2

RUN pecl install xdebug-2.7.2 \
    && docker-php-ext-enable xdebug

RUN apt-get update \
 && apt-get install -y git wget tar libzip-dev \
 && docker-php-ext-install zip

WORKDIR /usr/bin

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') === 'e0012edf3e80b6978849f5eff0d4b4e4c79ff1609dd1e613307e16318854d24ae64f26d17af3ef0bf7cfb710ca74755a') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');"

WORKDIR /tmp
RUN wget https://s3.amazonaws.com/mountebank/v2.0/mountebank-v2.0.0-linux-x64.tar.gz \
    && tar -xf mountebank-v2.0.0-linux-x64.tar.gz \
    && cp -r mountebank-v2.0.0-linux-x64/* /usr/bin/ \
    && rm -rf mountebank-v2.0.0-linux-x64*

RUN mkdir /src
COPY . /src

WORKDIR /src
RUN composer.phar install
