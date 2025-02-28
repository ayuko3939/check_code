#!/bin/bash
set -e

# --- データベースの起動待ち処理 ---
# WORDPRESS_DB_HOST にはデータベースのホスト名（例: mariadb）が設定されている前提です。
# echo "Waiting for MariaDB to be ready..."
while ! mysqladmin ping -h "$WORDPRESS_DB_HOST" --silent; do
  # echo "MariaDB is not ready yet. Waiting..."
  sleep 2
done
# echo "MariaDB is ready."

# --- WordPress の初期設定 ---
# /var/www/html/wp-config.php が存在しなければ、WordPress のダウンロードと設定を実行
if [ ! -f /var/www/html/wp-config.php ]; then
  # echo "wp-config.php が見つかりません。WordPress の初期設定を実行します。"

  cd /var/www/html
  
  # WordPress コアのダウンロード（--path で設置先ディレクトリを指定）
  wp core download --path=/var/www/html --locale=ja --allow-root
  
  # WordPress の設定ファイル (wp-config.php) を生成
  wp config create \
    --dbname="$MYSQL_DATABASE" \
    --dbuser="$MYSQL_USER" \
    --dbpass="$MYSQL_PASSWORD" \
    --dbhost="$WORDPRESS_DB_HOST" \
    --allow-root \
    --skip-check
  
  # WordPress のインストール実行
  wp core install \
    --url="$DOMAIN" \
    --title="$WORDPRESS_SITE_TITLE" \
    --admin_user="$WORDPRESS_ADMIN_USER" \
    --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
    --admin_email="$WORDPRESS_ADMIN_EMAIL" \
    --skip-email \
    --allow-root
fi

# --- PHP-FPM の起動 ---
# 最終的に PHP-FPM をフォアグラウンドで起動し、コンテナのメインプロセスとする
exec php-fpm7.4 -F