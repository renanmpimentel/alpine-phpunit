FROM alpine:latest

ENV XDEBUG_VERSION 2.3.3

RUN apk --update --no-progress add bash wget curl git build-base php-dev autoconf \
        php-fpm php-mcrypt php-curl php-dom php-gd php-json php-openssl \
        php-pdo_mysql php-pdo_sqlite php-phar php-iconv php-ctype \
        php-common php-cli php-gd php-pgsql php-bcmath php-imap php-memcache \
        php-ldap php-soap php-dba php-mcrypt php-xml php-dev php-mysqli \ 
        php-mysql php-xmlrpc php-enchant php-opcache php-fpm php-pdo \
    && rm -rf /var/cache/apk/* \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN apk add zlib && rm -rf /var/cache/apk/*
RUN wget http://xdebug.org/files/xdebug-$XDEBUG_VERSION.tgz \
    && tar -zxvf xdebug-$XDEBUG_VERSION.tgz && cd xdebug-$XDEBUG_VERSION \
    && phpize && ./configure --enable-xdebug && make && make install

RUN composer config --global github-protocols

COPY . /export/htdocs/
COPY ./conf/php.ini /etc/php/
COPY ./conf/php-fpm.conf /etc/php/

VOLUME /export/htdocs/

CMD ["/bin/sh"]
ENTRYPOINT ["/bin/sh", "-c"]
