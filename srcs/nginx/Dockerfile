FROM debian:bullseye

RUN apt update && apt install -y nginx openssl

COPY init.sh /docker-entrypoint.d/init.sh

ENTRYPOINT ["/docker-entrypoint.d/init.sh"]