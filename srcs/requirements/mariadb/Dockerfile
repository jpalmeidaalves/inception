FROM	alpine:3.18

# Install MariaDB client suite
RUN		apk update && apk upgrade && apk add mariadb mariadb-client

# Copy MariaDB configuration files to the container
COPY	./conf/configure-mariadb.sh /tmp/configure-mariadb.sh

# Make the configuration script executable
RUN		chmod +x /tmp/configure-mariadb.sh

# Execute the script when MariaDB container starts
ENTRYPOINT	[ "sh", "/tmp/configure-mariadb.sh" ]
