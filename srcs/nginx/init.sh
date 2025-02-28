#!/bin/bash
set -e

cd /etc/nginx/ssl

# 秘密鍵の作成
openssl genrsa -out inception.key 2048

# 証明書署名要求 (CSR) の作成
openssl req -new -key inception.key -out inception.csr \
    -subj "/C=JP/ST=Tokyo/L=Sinjuku/O=42Tokyo/CN=yohasega.42.fr"

# 自己署名証明書の作成 (有効期限 365 日)
openssl x509 -req -days 365 -in inception.csr -signkey inception.key -out inception.crt

exec nginx -g 'daemon off;'