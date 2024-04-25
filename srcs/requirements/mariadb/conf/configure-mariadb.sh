#!/bin/sh

echo -e "* Executing MariaDB configuration script *"

export DB_HOST=$(cat /run/secrets/db_host)
export DB_ROOT_PASS=$(cat /run/secrets/db_root_pass)
export WP_DB_USER=$(cat /run/secrets/wp_db_user)
export WP_DB_PASS=$(cat /run/secrets/wp_db_pass)


if [ ! -d "/run/mysqld" ]; then
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

if [ -d "/var/lib/mysql/mysql" ]
then
	echo "Variables are set. MariaDB is already configured."
else
	echo "* Creating MariaDB Directory"
	chown -R mysql:mysql /var/lib/mysql
	mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm > /dev/null
	echo "* MySQL Data Directory done."

	echo "* Configuring MySQL..."

	
	# Make a hidden file to store the MySQL commands
	TMP=/tmp/.tmpfile

	# Write the MySQL commands to the .tmpfile
	echo "USE mysql;" > ${TMP}
	echo "FLUSH PRIVILEGES;" >> ${TMP}
	echo "DELETE FROM mysql.user WHERE User='';" >> ${TMP}
	echo "DROP DATABASE IF EXISTS test;" >> ${TMP}
	echo "DELETE FROM mysql.db WHERE Db='test';" >> ${TMP}
	echo "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');" >> ${TMP}
	echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASS}';" >> ${TMP}
	echo "CREATE DATABASE ${WP_DB_NAME};" >> ${TMP}
	echo "CREATE USER '${WP_DB_USER}'@'%' IDENTIFIED BY '${WP_DB_PASS}';" >> ${TMP}
	echo "GRANT ALL PRIVILEGES ON ${WP_DB_NAME}.* TO '${WP_DB_USER}'@'%' IDENTIFIED BY '${WP_DB_PASS}';" >> ${TMP}
	echo "FLUSH PRIVILEGES;" >> ${TMP}

	# Execute mysql command with the .tmpfile as input
	# Run mysqld as the user mysql instead as root for security reasons
	# --bootstrap: only accepts the initial connection from an administrative client
	/usr/bin/mysqld --user=mysql --bootstrap < ${TMP}
	rm -f ${TMP}
	echo "* MySQL configured successfully."
fi

# edit the mariadb-server.cnf file to allow remote connections listening for TCP/IP connections.
sed -i "s|skip-networking|# skip-networking|g" /etc/my.cnf.d/mariadb-server.cnf
# set the bind-address to listen to all addresses in the machine
sed -i "s|.*bind-address\s*=.*|bind-address=0.0.0.0|g" /etc/my.cnf.d/mariadb-server.cnf

echo "* Starting MariaDB daemon on port 3306."

# Start the MySQL daemon as mysql user and stats to display the logs on the console
exec /usr/bin/mysqld --user=mysql --console
