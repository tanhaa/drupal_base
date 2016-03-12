FROM centos:7
MAINTAINER Amit Malhotra <amit08@gmail.com>

# Set US locale
RUN localedef --quiet -c -i en_US -f UTF-8 en_US.UTF-8
ENV LANGUAGE en_US
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV TERM dumb

RUN yum clean all && \
    yum update -y && \
    yum install -y epel-release && \
    yum install -y python-pip \
    python34.x86_64 \
    wget \
    php-cli \
    php-fpm \
    php-gd \
    php-mbstring \
    php-xml \
    php-pdo \
    php-mysql \
    openssh-clients.x86_64 \
    rsync \
    mariadb \
    nginx

# Install pip for python3
RUN curl https://bootstrap.pypa.io/get-pip.py | python3 -
RUN pip3 install PyMySQL

WORKDIR /tmp
# Install drush
RUN wget http://files.drush.org/drush.phar
RUN php drush.phar core-status
RUN chmod +x drush.phar && mv drush.phar /usr/local/bin/drush

# Install supervisor
RUN pip2 install supervisor
COPY templates/etc/supervisord.conf /etc/supervisord.conf

# These settings can allow this container to only run php-fpm and have another nginx container send fast-cgi requests
# to this container
RUN sed -i '/^listen = /clisten = 0.0.0.0:9000' /etc/php-fpm.d/www.conf
RUN sed -i '/^listen.allowed_clients/c;listen.allowed_clients =' /etc/php-fpm.d/www.conf
RUN sed -i '/^;listen.mode = 0666/clisten.mode = 0750' /etc/php-fpm.d/www.conf

RUN sed -i '/^;catch_workers_output/ccatch_workers_output = yes' /etc/php-fpm.d/www.conf
RUN sed -i 's#php_admin_value\[error_log\] = /var/log/php-fpm/www-error.log#php_admin_value\[error_log\] = /proc/self/fd/2#g' /etc/php-fpm.d/www.conf


RUN sed -i '/^user = apache/cuser = nginx' /etc/php-fpm.d/www.conf
RUN sed -i '/^group = apache/cgroup = nginx' /etc/php-fpm.d/www.conf

EXPOSE 9000

# ENTRYPOINT /usr/sbin/php-fpm --nodaemonize
