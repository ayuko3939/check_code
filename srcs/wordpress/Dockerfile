# ベースイメージとして Debian Bullseye を使用
FROM debian:bullseye

# パッケージリストを更新
RUN apt-get update -y

# 必要なパッケージをインストール pho-fpm7.4
RUN apt install -y php7.4 \
                   php7.4-fpm \
                   php7.4-cli \
                   php7.4-common \
                   php7.4-mysql \
                   php7.4-gd \
                   php7.4-mbstring \
                   php7.4-curl \
                   php7.4-xml

RUN apt install -y mariadb-client curl

# WP-CLI（WordPress コマンドラインツール）をダウンロード
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

# WordPress 用のディレクトリを作成
RUN mkdir -p /var/www/html

# ダウンロードしたファイルを実行可能にし、システム全体で使えるように配置
RUN chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

# /var/www/html の所有者を www-data ユーザーに変更
RUN chown -R www-data:www-data /var/www/html

# 必要ファイルを生成する為PHP-FPM サービスを一度起動して停止
RUN service php7.4-fpm start && service php7.4-fpm stop

# カスタム PHP-FPM 設定ファイルをコピー
COPY www.conf /etc/php/7.4/fpm/pool.d/www.conf

# カスタムエントリーポイントスクリプトをコピー
COPY init.sh /docker-entrypoint.d/init.sh

# エントリーポイントスクリプトを実行（コンテナ起動時に実行される）
ENTRYPOINT ["/docker-entrypoint.d/init.sh"]