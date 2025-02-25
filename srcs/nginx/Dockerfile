FROM debian:bullseye

RUN apt update
RUN apt install -y nginx openssl nginx curl

COPY init.sh /docker-entrypoint-initdb.d/init.sh

ENTRYPOINT ["/docker-entrypoint-initdb.d/init.sh"]