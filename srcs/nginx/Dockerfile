FROM debian:bullseye

RUN apt-get update && apt-get install -y nginx openssl

COPY init.sh /docker-entrypoint.d/init.sh

ENTRYPOINT ["/docker-entrypoint.d/init.sh"]