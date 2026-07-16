#!/bin/sh

# 1. Check if system tables already exist
if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
    echo "Database not initialized. Initializing system tables..."
   
    echo "FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'localhost';
FLUSH PRIVILEGES;" | mysqld --user=mysql --bootstrap

fi

# 2. change the owner of this directory to mysql user (not root user!!)
chown -R mysql:mysql /var/lib/mysql

# 3. execute the mysql program by mysql user inside container
exec mysqld --user=mysql
