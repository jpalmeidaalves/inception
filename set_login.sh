#!/bin/bash

if ! grep -q ${DOMAIN} "/etc/hosts"; then
	echo "127.0.0.1 ${DOMAIN}" | sudo tee -a /etc/hosts
fi

sed -i "s/login/${LOGIN}/g" srcs/.env
sed -i "s/login/${LOGIN}/g" srcs/requirements/nginx/conf/default.conf
sed -i "s/login/${LOGIN}/g" secrets/ftp_user.txt
sed -i "s/login/${LOGIN}/g" secrets/wp_admin_user.txt
sed -i "s/login/${LOGIN}/g" secrets/wp_user.txt
sed -i "s/login/${LOGIN}/g" secrets/wp_db_user.txt