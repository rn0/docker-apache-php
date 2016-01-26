FROM ubuntu:14.04

ENV TERM xterm

RUN apt-get update -y && apt-get install -y software-properties-common language-pack-en-base && \
    LC_ALL=en_US.UTF-8 add-apt-repository -y ppa:ondrej/php-7.0 && \
    apt-get update -y && apt-get install -y \
    vim \
    mc \
    acl \
    apache2 \
    python-pycurl \
    php7.0 \
    php7.0-cli \
    php7.0-gd \
    php7.0-mysql \
    php7.0-curl \
    php7.0-intl \
    php7.0-mcrypt \
    php-xdebug \
    python-mysqldb \
    python-selinux && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY application.conf /etc/apache2/sites-available/application.conf
COPY php_config.ini /etc/php/7.0/mods-available/
COPY xdebug.ini /etc/php/7.0/mods-available/
RUN ln -s /etc/php/7.0/mods-available/php_config.ini /etc/php/7.0/apache2/conf.d/ && \
    ln -s /etc/php/7.0/mods-available/php_config.ini /etc/php/7.0/cli/conf.d/

RUN a2enmod rewrite && \
    echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    a2dissite 000-default && \
    a2dissite default-ssl && \
    a2ensite application && \
    rm -rf /var/www/html

VOLUME /var/www/application
EXPOSE 80

CMD /usr/sbin/apache2ctl -D FOREGROUND
