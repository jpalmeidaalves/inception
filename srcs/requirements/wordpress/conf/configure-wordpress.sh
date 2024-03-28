#!/bin/sh

# Define color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "${BLUE}WordPress${NC} Configuring WordPress..."

attempt_counter=0
max_attempts=10

while ! mariadb -h${DB_HOST} -u${WP_DB_USER} -p${WP_DB_PASS} ${WP_DB_NAME} &>/dev/null;
do
    sleep 3
    attempt_counter=$((attempt_counter+1))
    if [ $attempt_counter -eq $max_attempts ]; then
        echo "${RED}Max attempts reached, exiting.${NC}"
        exit 1
    fi
done

echo "${BLUE}WordPress${NC} Database found."

WP_PATH=/var/www/html/wordpress

if [ -f ${WP_PATH}/wp-config.php ]
then
	echo "${BLUE}WordPress${NC} WordPress already configured."
else
	echo "${BLUE}WordPress${NC} Setting up WordPress..."
	wp cli update --yes --allow-root
	wp core download --allow-root
	wp config create --dbname=${WP_DB_NAME} --dbuser=${WP_DB_USER} --dbpass=${WP_DB_PASS} --dbhost=${DB_HOST} --path=${WP_PATH} --allow-root
	wp core install --url=${NGINX_HOST}/wordpress --title=${WP_TITLE} --admin_user=${WP_ADMIN_USER} --admin_password=${WP_ADMIN_PASS} --admin_email=${WP_ADMIN_EMAIL} --path=${WP_PATH} --allow-root
	wp user create $WP_USER ${WP_USER_EMAIL} --user_pass=${WP_USER_PASS} --role=subscriber --display_name=${WP_USER} --porcelain --path=${WP_PATH} --allow-root
	wp theme install twentyseventeen --path=${WP_PATH} --activate --allow-root
	wp theme status twentyseventeen --allow-root
fi

echo "${BLUE}WordPress${NC} Starting WordPress fastCGI on port 9000."
exec /usr/sbin/php-fpm81 -F -R
