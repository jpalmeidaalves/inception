FROM	alpine:3.18

# Install nginx and create necessary directories
RUN		apk update && apk upgrade && apk add nginx &&\
		mkdir -p /var/www/html/

# Copy the configuration files to the container
COPY	./conf/nginx.conf /etc/nginx/nginx.conf
COPY	./conf/default.conf /etc/nginx/http.d/default.conf

# Install openssl and create a self-signed certificate for HTTPS
RUN		apk add openssl && openssl req -x509 -nodes\
			-days 365 -newkey rsa:2048\
			-keyout /etc/ssl/private/nginx-selfsigned.key\
			-out /etc/ssl/certs/nginx-selfsigned.crt\
			-subj "/C=PT/ST=P/L=Porto/O=42/OU=Porto/CN=joaoalme"

# Create a user and group www to run nginx 
RUN		adduser -D -g 'www' www &&\
		chown -R www:www /run/nginx/ &&\
		chown -R www:www /var/www/html/

# Expose the port 443 as stated in the subject
EXPOSE	443/tcp

# Run nginx with daemon off, i.e. in the foreground since one container only
# has one service. This is best practice for Docker containers and/or debugging.
ENTRYPOINT	["nginx"]
CMD			["-g", "daemon off;"]
