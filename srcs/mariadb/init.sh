#!/bin/bash
# set -e

# PHPファイルで書いてしまうとENVを使えない為、動的に init.sql を作成
cat << EOF > /docker-entrypoint-initdb.d/init.sql
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

# echo "init.sql has been generated."

mariadbd --init-file=/docker-entrypoint-initdb.d/init.sql

# # MariaDB の起動
# mysqld_safe &

# # MariaDB の準備が整うのを待つ
# # until mysqladmin ping -h localhost --silent; do
# #   echo "Waiting for MariaDB to be ready..."
# #   sleep 2
# # done
# sleep 5

# # 手動で init.sql を実行
# mysql -u root -p"${MYSQL_ROOT_PASSWORD}" < /docker-entrypoint-initdb.d/init.sql

# # MariaDB プロセスを前面で実行し続ける
# # wait