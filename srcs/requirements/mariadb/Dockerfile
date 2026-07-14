FROM debian:bookworm

RUN apt-get update && \
	apt-get install -y mariadb-server && \
	rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/mysqld && \
	chown -R mysql:mysql /var/run/mysqld && \
	chmod 777 /var/run/mysqld

EXPOSE 3306

CMD ["mysqld", "--bind-address=0.0.0.0", "--user=mysql"]
