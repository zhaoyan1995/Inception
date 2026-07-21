FROM debian:bookworm

RUN apt-get update && \
	apt-get install -y mariadb-server && \
	rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/mysqld && \
	chown -R mysql:mysql /var/run/mysqld && \
	chmod 777 /var/run/mysqld

COPY tools/entrypoint.sh /entrypoint.sh

RUN sed -i 's/bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/g' /etc/mysql/mariadb.conf.d/50-server.cnf

RUN chmod +x /entrypoint.sh && chown mysql:mysql /entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["/entrypoint.sh"]
