FROM ubuntu:14.04
MAINTAINER Nic <tuananh.exp@gmail.com>

# Setup environment
ENV DEBIAN_FRONTEND noninteractive

# Update sources
RUN apt-get update -y

# Install Python properties common
RUN apt-get install -y software-properties-common

# Add php repository
RUN add-apt-repository -y ppa:ondrej/php

# Update sources
RUN apt-get update -y

# install php
RUN apt-get install -y --force-yes libapache2-mod-php5.6 php5.6-cli php5.6-curl php5.6-dev php5.6-fpm php5.6-mcrypt \
	php5.6 php5.6-xml php5.6-mbstring php5.6-common php5.6-pgsql php5.6-xsl php5.6-recode php5.6-zip php5.6-soap\
	php-memcached php-xdebug php5.6-gd php5.6-json php-mongo php5.6-mysql php5.6-intl php5.6-imap php5.6-snmp && \
	curl -sS https://getcomposer.org/installer | php
	# mv composer.phar /usr/local/bin/composer
# RUN apt-get install -y php5 php5-mysql php5-dev php5-gd php5-memcache php5-pspell php5-snmp snmp php5-xmlrpc libapache2-mod-php5 php5-cli
#RUN yum install -y php php-mysql php-devel php-gd php-pecl-memcache php-pspell php-snmp php-xmlrpc php-xml

# install http
RUN apt-get install -y apache2 vim bash-completion unzip
RUN mkdir -p /var/lock/apache2 /var/run/apache2

# install mysql
RUN apt-get install -y mysql-client mysql-server
#RUN echo "NETWORKING=yes" > /etc/sysconfig/network
# start mysqld to create initial tables
#RUN service mysqld start

# install supervisord

RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor

# install sshd
RUN apt-get install -y openssh-server openssh-client passwd
RUN mkdir -p /var/run/sshd

#RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key 
RUN sed -ri 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
RUN echo 'root:changeme' | chpasswd

# Put your own public key at id_rsa.pub for key-based login.
RUN mkdir -p /root/.ssh && touch /root/.ssh/authorized_keys && chmod 700 /root/.ssh
#ADD id_rsa.pub /root/.ssh/authorized_keys


ADD phpinfo.php /var/www/html/
ADD supervisord.conf /etc/
EXPOSE 22 80 443

CMD ["supervisord", "-n"]