FROM alpine:3.18

RUN		apk update && apk upgrade && \
        apk add php81 php81-fpm && \
        apk add python3 && \
        apk add make && \
        apk add g++ 
RUN     mkdir ./webserv

COPY    ./conf/ ./webserv

WORKDIR /webserv

RUN     make

EXPOSE 8084 8086


CMD [ "./webserv", "configFile.conf"]

