#!/bin/bash

# This script erases all personal data from the project

sudo sed -i "/127.0.0.1 ${DOMAIN}/d" /etc/hosts
sed -i "s/${LOGIN}/login/g" srcs/.env
sed -i "s/${LOGIN}/login/g" srcs/requirements/nginx/conf/default.conf
sed -i "s/${LOGIN}/login/g" Makefile
# rm /src/.env


