FROM debian:bookworm

RUN apt-get update && apt-get install -y\
	php8.2-fpm \
	php8.2-mysql \
	mariadb-client \
	curl \
	wget \
	unzip \
	&& rm -rf /var/lib/apt/lists/*

# 2. 安装 wp-cli (WordPress 命令行工具，自动部署的神器)
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

RUN mkdir -p /run/php

RUN sed -i 's|listen = /run/php/php8.2-fpm.sock|listen = 9000|g' /etc/php/8.2/fpm/pool.d/www.conf

COPY tool/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["/entrypoint.sh"]
