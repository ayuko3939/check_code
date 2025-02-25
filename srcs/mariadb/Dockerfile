FROM debian:bullseye

RUN apt update && apt install -y mariadb-server mariadb-client
RUN mkdir /var/run/mysqld
RUN chown -R mysql:mysql /var/run/mysqld

COPY my.cnf /etc/mysql/my.cnf
COPY init.sh /docker-entrypoint-initdb.d/init.sh

ENTRYPOINT ["/docker-entrypoint-initdb.d/init.sh"]