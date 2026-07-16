#!/bin/sh

# 1. Check if system tables already exist
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Database not initialized. Initializing system tables..."
    
    # Initialize the data directory and create system tables 
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
   
    echo "FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%';
FLUSH PRIVILEGES;" | mysqld --user=mysql --bootstrap

fi 

# 2. change the owner of this directory to mysql user (not root user!!)
chown -R mysql:mysql /var/lib/mysql

# 3. execute the mysql program by mysql user inside container
exec mysqld --user=mysql
