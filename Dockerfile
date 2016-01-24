FROM ubuntu:14.04

ENV TERM xterm

RUN apt-get update -y && apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:ondrej/php && \
    apt-get update -y && apt-get install -y \
    vim \
    mc \
    acl \
    apache2 \
    python-pycurl \
    php5 \
    php-apc \
    php5-cli \
    php5-gd \
    php5-mysql \
    php5-curl \
    php5-intl \
    php5-mcrypt \
    php5-xdebug \
    python-mysqldb \
    python-selinux

COPY application.conf /etc/apache2/sites-available/application.conf
COPY php_config.ini /etc/php5/mods-available/
COPY xdebug.ini /etc/php5/mods-available/
RUN ln -s /etc/php5/mods-available/php_config.ini /etc/php5/apache2/conf.d/

RUN a2enmod rewrite && \
    echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    a2dissite 000-default && \
    a2dissite default-ssl && \
    a2ensite application && \
    rm -rf /var/www/html

VOLUME /var/www/application
EXPOSE 80

CMD /usr/sbin/apache2ctl -D FOREGROUND
