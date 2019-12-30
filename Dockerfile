FROM debian:buster
MAINTAINER Mahyuddin Susanto <udienz@gmail.com>

ENV CACTI_VERSION=1.2.8

RUN apt update && \
    apt dist-upgrade -y -q && \
    apt install -y -q autoconf automake default-libmysqlclient-dev libssl-dev libsnmp-dev libcap-dev \
    libtool help2man po-debconf dos2unix debhelper-compat

RUN curl -L -o /tmp/spine-${CACTI_VERSION}.tgz https://github.com/Cacti/spine/archive/release/${CACTI_VERSION}.tar.gz && \
    mkdir -p /tmp/spine && \
    tar zxvf /tmp/spine-${CACTI_VERSION}.tgz -C /tmp/spine --strip-components=1 && \
    rm -f /tmp/spine-${CACTI_VERSION}.tgz && \
    cd /tmp/spine/ && ./bootstrap && ./configure --with-reentrant && make && make install && \
    chown root:root /usr/local/spine/bin/spine && \
    chmod +s /usr/local/spine/bin/spine && \
    rm -rf /tmp/spine && \
    apt remove -y autoconf automake default-libmysqlclient-dev libssl-dev libsnmp-dev libcap-dev \
    libtool help2man po-debconf debhelper-compat && \
    apt-get autoremove -y && \
    apt-get autoclean -y

RUN apt update && \
    apt dist-upgrade -y -q && \
    apt-get install -y -q apache2 libapache2-mod-php \
    perl php-cli php-gmp php-json php-ldap php-mbstring php-mysql php-phpseclib \
    php-snmp php-twig php-xml rrdtool snmp ucf mariadb-client curl

RUN  curl -L -o /tmp/cacti-${CACTI_VERSION}.tgz https://github.com/Cacti/cacti/archive/release/1.1.12.tar.gz && \
    mkdir -p /var/www/html && tar zxvf /tmp/cacti-${CACTI_VERSION}.tgz -C /var/www/html --strip-components=1 && \
    rm -rf /tmp/cacti-${CACTI_VERSION}.tgz && \
    rm /var/www/html/index.html && \
    chown www-data.www-data /var/www/html/log/ /var/www/html/rra/

STOPSIGNAL SIGWINCH

COPY apache2-foreground /usr/local/bin/
WORKDIR /var/www/html

EXPOSE 80
CMD ["apache2-foreground"]
