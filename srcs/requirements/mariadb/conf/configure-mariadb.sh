#!/bin/sh

# Define color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}* Executing MariaDB configuration script *${NC}"

# Check if the required environment variables are set
if [ ! -d "/run/mysqld" ]; then
	# If the directory does not exist, create it and grant permissions
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

# Check if the required environment variables are set
if [ -d "/var/lib/mysql/mysql" ]
then
	echo "${BLUE}Variables are set. MariaDB is already configured.${NC}"
else
	echo "${BLUE}[MariaDB]${NC} Creating MariaDB Directory"
	chown -R mysql:mysql /var/lib/mysql
	mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm > /dev/null
	echo "${BLUE}[MariaDB]${NC} MySQL Data Directory done."

	echo "${BLUE}[MariaDB]${NC} Configuring MySQL..."
	
	# Create a temporary file to store the MySQL commands
	TMP=/tmp/.tmpfile

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

	# Start the MySQL daemon and execute the MySQL commands
	# --user=mysql: Run mysqld as the user mysql 
	# --bootstrap < file: Execute the MySQL commands stored in the file 
	/usr/bin/mysqld --user=mysql --bootstrap < ${TMP}
	rm -f ${TMP}
	echo "${BLUE}[MariaDB]${NC} MySQL configuration done."
fi
# edit the mariadb-server.cnf file to allow remote connections listening for TCP/IP connections.
sed -i "s|skip-networking|# skip-networking|g" /etc/my.cnf.d/mariadb-server.cnf
# set the bind-address to listen o all addresses in the machine
sed -i "s|.*bind-address\s*=.*|bind-address=0.0.0.0|g" /etc/my.cnf.d/mariadb-server.cnf

echo "${BLUE}[MariaDB]${NC} Starting MariaDB daemon on port 3306."
# Start the MySQL daemon as mysql user and stats to display the logs on the console
exec /usr/bin/mysqld --user=mysql --console
