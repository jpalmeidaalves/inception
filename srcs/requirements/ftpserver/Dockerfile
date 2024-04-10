FROM alpine:3.18

RUN	apk update && apk upgrade && apk add --no-cache \
        vsftpd

COPY conf/vsftpd.conf /tmp/vsftpd.conf

COPY conf/config_ftp.sh /tmp/config_ftp.sh
ENTRYPOINT ["sh", "/tmp/config_ftp.sh"]