#!/bin/bash
set -e

while ! mysqladmin ping -h "$WORDPRESS_DB_HOST" --silent; do
  sleep 2
done

if [ ! -f /var/www/html/wp-config.php ]; then

  cd /var/www/html
  
  wp core download --path=/var/www/html --locale=ja --allow-root
  
  wp config create \
    --dbname="$MYSQL_DATABASE" \
    --dbuser="$MYSQL_USER" \
    --dbpass="$MYSQL_PASSWORD" \
    --dbhost="$WORDPRESS_DB_HOST" \
    --allow-root \
    --skip-check
  
  wp core install \
    --url="$DOMAIN" \
    --title="$WORDPRESS_SITE_TITLE" \
    --admin_user="$WORDPRESS_ADMIN_USER" \
    --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
    --admin_email="$WORDPRESS_ADMIN_EMAIL" \
    --skip-email \
    --allow-root

  wp user create \
    "${WORDPRESS_EDITOR_USER}" \
    "${WORDPRESS_EDITOR_EMAIL}" \
    --user_pass="${WORDPRESS_EDITOR_PASSWORD}" \
    --role=editor \
    --allow-root
fi

exec php-fpm7.4 -F