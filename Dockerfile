FROM centos:8
RUN yum -y update && yum clean all
RUN yum -y install httpd mod_fcgid && yum clean all
RUN echo "ServerName localhost" > /etc/httpd/conf.d/ServerName.conf
RUN echo -e '\
<VirtualHost *:80> \n\
    ServerAdmin redes@riocard.com \n\
    DocumentRoot /var/www/html \n\
	ServerAlias 127.0.0.1 \n\
	SetEnvIf Remote_Addr "127.0.0.1" dontlog \n\
	SetEnvIf Remote_Addr "::1" dontlog \n\
    <Location /server-status> \n\
	    SetHandler server-status \n\
	    #Order Deny,Allow \n\
	    Deny from all \n\
	    Allow from 127 \n\
	    Allow from ::1 \n\
            Allow from 172.17.0.1 \n\
    </Location> \n\
</VirtualHost> \
' > /etc/httpd/conf.d/server-status.conf
RUN echo "ExtendedStatus On" > /etc/httpd/conf.d/ExtendedStatus.conf
RUN echo -e '\
LogFormat "%h - %{X-Forwarded-For}i %l %u \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" custom \n\
CustomLog "/var/log/httpd/access_log" custom env=!dontlog \n\
ErrorLog "/var/log/httpd/error_log" \
' > /etc/httpd/conf.d/log.conf
RUN sed -i 's/CustomLog/#CustomLog/g' /etc/httpd/conf/httpd.conf
RUN ln -sf /proc/self/fd/1 /var/log/httpd/access_log && \
    ln -sf /proc/self/fd/1 /var/log/httpd/error_log
RUN rm -rf /var/www/html/
COPY ./html /var/www/html/
COPY ./vhosts.conf /etc/httpd/conf.d/vhosts.conf
VOLUME /var/www/html
EXPOSE 80
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
