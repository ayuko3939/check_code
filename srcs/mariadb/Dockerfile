FROM debian:bullseye

RUN apt update && apt install -y mariadb-server mariadb-client

COPY my.cnf /etc/mysql/my.cnf
COPY init.sh /docker-entrypoint-initdb.d/init.sh

ENTRYPOINT ["/docker-entrypoint-initdb.d/init.sh"]