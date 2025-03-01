#!/bin/bash
set -e

cd /etc/nginx/ssl

openssl genrsa -out inception.key 2048

openssl req -new -key inception.key -out inception.csr \
    -subj "/C=JP/ST=Tokyo/L=Sinjuku/O=42Tokyo/CN=yohasega.42.fr"

openssl x509 -req -days 365 -in inception.csr -signkey inception.key -out inception.crt

exec nginx -g 'daemon off;'