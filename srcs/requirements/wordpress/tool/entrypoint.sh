#!/bin/sh

set -e

# 1. Make sure that Mariadb is connected
echo "check if mariadb is connected..."

while ! mysqladmin ping -h"mariadb" -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" --silent; do
	echo "Maria db is not ready yet, WordPress need to wait for 2 seconds."
	sleep 2
done
echo "mariadb is connected sucessfully!"


# 2. Downloading the WordPress source code 
if [ ! -f /var/www/html/index.php ]; then
    echo "WordPress source code doesn't exist, uploading now..."
    wp core download --allow-root --path=/var/www/html
fi

# 3. Build the wp-config.php config file
if [ ! -f /var/www/html/wp-config.php ]; then
	echo "creating the wp-config.php config file and bind to Mairadb DataBase"
	wp config create \
		--allow-root \
		--dbname="${MYSQL_DATABASE}" \
		--dbuser="${MYSQL_USER}" \
		--dbpass="${MYSQL_PASSWORD}" \
		--dbhost="mariadb:3306" \
		--path=/var/www/html

	echo "installing wordpress automatically"
	wp core install \
		--allow-root \
		--url="${WP_URL}" \
		--title="${WP_TITLE}" \
		--admin_user="${WP_ADMIN_USER}" \
		--admin_password="${WP_ADMIN_PASSWORD}" \
		--admin_email="${WP_ADMIN_EMAIL}" \
		--skip-email \
		--path=/var/www/html
fi

echo "updating the access rule of web directory file"

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# 启动 php-fpm
exec php-fpm8.2 -F

