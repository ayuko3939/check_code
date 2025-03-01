FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y \
      php7.4 \
      php7.4-fpm \
      php7.4-cli \
      php7.4-mysql \
      mariadb-client \
      curl

RUN mkdir -p /var/www/html

RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x /usr/local/bin/wp

RUN chown -R www-data:www-data /var/www/html

RUN service php7.4-fpm start && service php7.4-fpm stop

COPY www.conf /etc/php/7.4/fpm/pool.d/www.conf

COPY init.sh /docker-entrypoint.d/init.sh

ENTRYPOINT ["/docker-entrypoint.d/init.sh"]