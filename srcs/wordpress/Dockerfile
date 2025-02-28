# 1. ベースイメージの指定：Debian Bullseye を使用
FROM debian:bullseye

# 2. パッケージリストの更新と3. 必要なパッケージのインストール
# 必須のパッケージのみをインストール（PHP本体、PHP-FPM、PHP-CLI、MySQL連携用、MariaDBクライアント、curl）
RUN apt-get update -y && \
    apt-get install -y \
      php7.4 \
      php7.4-fpm \
      php7.4-cli \
      php7.4-mysql \
      mariadb-client \
      curl

# 4. WordPress 用ディレクトリの作成
RUN mkdir -p /var/www/html

# 5. WP-CLI の導入
# /usr/local/bin/wp に直接ダウンロードし、実行可能にする
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x /usr/local/bin/wp

# 6. ディレクトリの所有権・権限の設定 ( /var/www/html の所有者を www-data に変更)
RUN chown -R www-data:www-data /var/www/html

# # 7. PHP-FPM 用のログディレクトリ作成と権限設定
# RUN mkdir -p /var/log/php-fpm/ && \
#     chown -R www-data:www-data /var/log/php-fpm/

# 8. PHP-FPM の初期化
# PHP-FPM を一度起動して停止させることで、必要な初期ファイル（例：ソケットなど）を生成する
RUN service php7.4-fpm start && service php7.4-fpm stop

# 9. カスタム PHP-FPM 設定ファイル（www.conf）のコピー
COPY www.conf /etc/php/7.4/fpm/pool.d/www.conf

# 10. カスタムエントリーポイントスクリプトのコピー
# コンテナ起動時に WordPress の初期設定を行うためのスクリプトをコピーする
COPY init.sh /docker-entrypoint.d/init.sh

# エントリーポイントスクリプトに実行権限を付与
# RUN chmod +x /docker-entrypoint.d/init.sh

# 11. コンテナ起動時のエントリーポイント設定
# コンテナ起動時に init.sh が実行され、最終的に PHP-FPM をフォアグラウンドで起動する
ENTRYPOINT ["/docker-entrypoint.d/init.sh"]