#!/bin/sh

echo "WordPress | Configuring WordPress..."

export DB_HOST=$(cat /run/secrets/db_host)
export DB_ROOT_PASS=$(cat /run/secrets/db_root_pass)

attempt_counter=0
max_attempts=10

# Make sure the database is up before configuring WordPress
while ! mariadb -h${DB_HOST} -u${WP_DB_USER} -p${WP_DB_PASS} ${WP_DB_NAME} &>/dev/null;
do
    sleep 3
    attempt_counter=$((attempt_counter+1))
    if [ $attempt_counter -eq $max_attempts ]; then
        echo "Max attempts reached, exiting."
        exit 1
    fi
done

echo "WordPress | Database found."

WP_PATH=/var/www/html/wordpress


if [ -f ${WP_PATH}/wp-config.php ]
then
	echo "WordPress | WordPress already configured."
else
	echo "WordPress | Setting up WordPress..."
	wp cli update --yes --allow-root
	wp core download --allow-root
	wp config create --dbname=${WP_DB_NAME} --dbuser=${WP_DB_USER} --dbpass=${WP_DB_PASS} --dbhost=${DB_HOST} --path=${WP_PATH} --allow-root
	wp core install --url=${NGINX_HOST}/wordpress --title=${WP_TITLE} --admin_user=${WP_ADMIN_USER} --admin_password=${WP_ADMIN_PASS} --admin_email=${WP_ADMIN_EMAIL} --path=${WP_PATH} --allow-root
	wp user create $WP_USER ${WP_USER_EMAIL} --user_pass=${WP_USER_PASS} --role=subscriber --display_name=${WP_USER} --porcelain --path=${WP_PATH} --allow-root
	wp theme install twentyseventeen --path=${WP_PATH} --activate --allow-root
	wp theme status twentyseventeen --allow-root
	wp post delete 1 --force --allow-root
	wp post create --post_type=post --post_title="Learning Docker" --post_content="In this project we learn Docker and also the basics of Nginx, Mariadb and wordpress!" --post_status=publish --allow-root
	# Configuring redis cache
	wp config set WP_REDIS_HOST redis --allow-root
	wp config set WP_REDIS_PORT 6379 --allow-root
	wp config set WP_CACHE true --allow-root
	wp plugin install redis-cache --activate --allow-root
	wp redis enable --allow-root
fi

echo "WordPress | Starting WordPress fastCGI on port 9000."
exec /usr/sbin/php-fpm81 -F -R
