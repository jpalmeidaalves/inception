FROM	alpine:3.18

RUN		apk update && apk upgrade && apk add nginx &&\
		mkdir -p /var/www/html/ && mkdir -p /etc/nginx/sites-enabled/ 

COPY	./conf/nginx.conf /etc/nginx/nginx.conf
COPY	./conf/default.conf /etc/nginx/sites-available/default.conf
COPY	./conf/tindog.conf /etc/nginx/sites-available/tindog.conf
RUN    ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf

RUN		apk add openssl && openssl req -x509 -nodes\
			-days 365 -newkey rsa:2048\
			-keyout /etc/ssl/private/nginx-selfsigned.key\
			-out /etc/ssl/certs/nginx-selfsigned.crt\
			-subj "/C=PT/ST=P/L=Porto/O=42/OU=Porto/CN=joaoalme"

RUN		adduser -D -g 'www' www &&\
		chown -R www:www /run/nginx/ &&\
		chown -R www:www /var/www/html/

EXPOSE	443/tcp

ENTRYPOINT	["nginx"]
CMD			["-g", "daemon off;"]
