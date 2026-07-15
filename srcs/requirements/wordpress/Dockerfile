FROM debian:bookworm

RUN apt-get update && \
	apt-get install -y php-fpm php-mysql wget && \
	rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/php

RUN sed -i 's|listen = /run/php/php8.2-fpm.sock|listen = 9000|g' /etc/php/8.2/fpm/pool.d/www.conf

COPY tool/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh


EXPOSE 9000

ENTRYPOINT ["/entrypoint.sh"]
