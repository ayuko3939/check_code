#!/bin/bash
set -e

# WordPress の設定が完了しているか確認
if [ ! -f /var/www/html/wp-config.php ]; then
  until mysqladmin ping -h "${WORDPRESS_DB_HOST}" --silent; do
    sleep 1
  done

  cd /var/www/html

  wp core download --path=/var/www/html --locale=ja --allow-root

  wp config create \
    --dbname="${MYSQL_DATABASE}" \
    --dbuser="${MYSQL_USER}" \
    --dbpass="${MYSQL_PASSWORD}" \
    --dbhost="${WORDPRESS_DB_HOST}" \
    --dbcharset="utf8mb4" \
    --dbcollate="utf8mb4_unicode_ci" \
    --path="/var/www/html" \
    --allow-root

  wp core install \
    --url="${DOMAIN}" \
    --title="${WORDPRESS_SITE_TITLE}" \
    --admin_user="${WORDPRESS_ADMIN_USER}" \
    --admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
    --admin_email="${WORDPRESS_ADMIN_EMAIL}" \
    --skip-email \
    --allow-root

  # サイトの一般設定を更新
  wp option update blogdescription "${WORDPRESS_SITE_DESCRIPTION}" --allow-root
  wp option update timezone_string "Asia/Tokyo" --allow-root

  # サブユーザーを作成
  wp user create \
  "${WORDPRESS_EDITOR_USER}" \
  "${WORDPRESS_EDITOR_EMAIL}" \
  --user_pass="${WORDPRESS_EDITOR_PASSWORD}" \
  --role=editor \
  --allow-root
fi

# PHP-FPM の起動
exec php-fpm7.4 -F