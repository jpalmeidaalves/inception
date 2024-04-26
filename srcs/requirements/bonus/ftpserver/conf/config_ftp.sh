#!/bin/sh
export FTP_USER=$(cat /run/secrets/ftp_user)
export FTP_PASS=$(cat /run/secrets/ftp_pass)

if [ ! -f "/etc/vsftpd/vsftpd.conf.bak" ]; then

    mkdir -p /var/www/html
    
    # Make a backup of the original vsftpd.conf file and replace it with the custom one
    cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.bak
    mv /tmp/vsftpd.conf /etc/vsftpd/vsftpd.conf

    # Create a FTP_USER
    adduser $FTP_USER --disabled-password
    # Change his password to the one in .env file
    echo "$FTP_USER:$FTP_PASS" | /usr/sbin/chpasswd &> /dev/null
    # Declare FTP_USER as owner of wordpress folder
    chown -R $FTP_USER:$FTP_USER /var/www/html

	#chmod +x /etc/vsftpd/vsftpd.conf
    # Appending the value of $FTP_USER to the end of the file /etc/vsftpd.userlist
    echo $FTP_USER | tee -a /etc/vsftpd.userlist &> /dev/null

fi

echo "ftp-server is running"
exec /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf