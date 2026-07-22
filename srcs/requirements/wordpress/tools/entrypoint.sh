#!/bin/sh

set -e

# 1. reading the database password 
if [ -f /run/secrets/db_password ]; then
	MYSQL_PASSWORD=$(cat /run/secrets/db_password)
fi

# 2. Make sure that Mariadb is connected
echo "check if mariadb is connected..."

MAX_RETRIES=30
RETRY_COUNT=0

while ! mysqladmin ping -h"mariadb" -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" --silent; do
    RETRY_COUNT=$((RETRY_COUNT + 1))
    if [ $RETRY_COUNT -ge $MAX_RETRIES ]; then
        echo "Error: MariaDB is still not ready after ${MAX_RETRIES} attempts (60s). Exiting."
        exit 1
    fi

    echo "MariaDB is not ready yet, waiting 2 seconds... ($RETRY_COUNT/$MAX_RETRIES)"
    sleep 2
done

echo "MariaDB is up and running!"

# 3. Downloading the WordPress source code 
if [ ! -f /var/www/html/index.php ]; then
    echo "WordPress source code doesn't exist, uploading now..."
    wp core download --allow-root --path=/var/www/html
fi

# 4. Reading credentials information and create new environnment variable in the script
if [ -f /run/secrets/credentials ]; then
    export $(cat /run/secrets/credentials | xargs)
fi

# 5. Build the wp-config.php config file
if [ ! -f /var/www/html/wp-config.php ]; then
	echo "creating the wp-config.php config file and bind to Mairadb DataBase"
	wp config create \
		--allow-root \
		--dbname="${MYSQL_DATABASE}" \
		--dbuser="${MYSQL_USER}" \
		--dbpass="${MYSQL_PASSWORD}" \
		--dbhost="mariadb:3306" \
		--path=/var/www/html

	echo "setting up the admin info account and basic info related to the website"
	wp core install \
		--allow-root \
		--url="${WP_URL}" \
		--title="${WP_TITLE}" \
		--admin_user="${WP_ADMIN_USER}" \
		--admin_password="${WP_ADMIN_PASSWORD}" \
		--admin_email="${WP_ADMIN_EMAIL}" \
		--skip-email \
		--path=/var/www/html
	
	echo "creating a normal wordpress user"
	wp user create \
		--allow-root \
		"${WP_USER}" \
		"${WP_USER_EMAIL}" \
		--role=author \
		--user_pass="${WP_USER_PASSWORD}"
fi

echo "updating the access rule of web directory file"

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# executing php-fpm
exec php-fpm8.2 -F

