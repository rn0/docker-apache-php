FROM ubuntu:14.04

ENV TERM xterm
ENV LANG en_US.UTF-8

RUN apt-get update -y && apt-get install -y software-properties-common language-pack-en-base && \
    export LANG=en_US.UTF-8 && add-apt-repository ppa:ondrej/php && add-apt-repository ppa:ondrej/php-qa && apt-get update -y && apt-get install -y \
    vim \
    mc \
    git \
    acl \
    apache2 \
    libapache2-mod-php5.6 \
    python-pycurl \
    php5.6 \
    php5.6-cli \
    php5.6-gd \
    php5.6-curl \
    php5.6-intl \
    php5.6-mcrypt \
    php5.6-bcmath \
    php5.6-xml \
    php5.6-readline \
    php5.6-json \
    php5.6-mysql \
    php5.6-sqlite3 \
    php5.6-mbstring \
    php5.6-soap \
    php5.6-zip \
    php-xdebug \
    python-mysqldb \
    python-selinux && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && php composer-setup.php --install-dir=/usr/bin && php -r "unlink('composer-setup.php');"

COPY application.conf /etc/apache2/sites-available/application.conf
COPY php_config.ini /etc/php/5.6/mods-available/
RUN ln -s /etc/php/5.6/mods-available/php_config.ini /etc/php/5.6/apache2/conf.d/80-php_config.ini && \
    ln -s /etc/php/5.6/mods-available/php_config.ini /etc/php/5.6/cli/conf.d/80-php_config.ini

RUN a2enmod rewrite && \
    echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    a2dissite 000-default && \
    a2dissite default-ssl && \
    a2ensite application && \
    rm -rf /var/www/html && \
    usermod -s /bin/bash www-data

RUN chown -R www-data:www-data /var/www

VOLUME /var/www/application
EXPOSE 80

WORKDIR /var/www/application

CMD rm -f /run/apache2/apache2.pid && /usr/sbin/apache2ctl -D FOREGROUND
