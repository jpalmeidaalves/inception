#!/bin/bash

# This script erases all personal data from the project

sudo sed -i "/127.0.0.1 ${DOMAIN}/d" /etc/hosts
sed -i "s/${LOGIN}/login/g" srcs/.env
sed -i "s/${LOGIN}/login/g" srcs/requirements/nginx/conf/default.conf
sed -i "s/${LOGIN}/login/g" Makefile
sed -i "s/${LOGIN}/login/g" secrets/ftp_user.txt
sed -i "s/${LOGIN}/login/g" secrets/wp_admin_user.txt
sed -i "s/${LOGIN}/login/g" secrets/wp_user.txt
sed -i "s/${LOGIN}/login/g" secrets/wp_db_user.txt
# rm /src/.env


