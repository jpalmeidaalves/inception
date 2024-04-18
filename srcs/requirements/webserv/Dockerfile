FROM alpine:3.18

RUN		apk update && apk upgrade && \
		apk add php81 php81-fpm && \
        apk add make && \
        apk add g++ 
RUN     mkdir ./webserv

COPY    ./conf/ ./webserv

WORKDIR /webserv

RUN     make

EXPOSE 8084 8086

ENTRYPOINT [ "./webserv", "configFile.conf"]

