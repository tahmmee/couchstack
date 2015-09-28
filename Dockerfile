FROM ubuntu:14.04

RUN apt-get update
RUN apt-get install ubuntu-cloud-keyring
RUN echo "deb http://ubuntu-cloud.archive.canonical.com/ubuntu"  "trusty-updates/kilo main" > /etc/apt/sources.list.d/cloudarchive-kilo.list
RUN apt-get update

#MYSQL 
RUN apt-get install -y mariadb-server python-mysqldb
COPY conf/mysqld_openstack.cnf /etc/mysql/conf.d/mysqld_openstack.cnf

#RABBITMQ
RUN apt-get install -y rabbitmq-server

# KEYSTONE
RUN echo "manual" > /etc/init/keystone.override
RUN apt-get install -y keystone python-openstackclient apache2 libapache2-mod-wsgi memcached python-memcache
COPY conf/keystone.conf /etc/keystone/keystone.conf 

# APACHE
RUN apt-get install -y curl
COPY conf/wsgi-keystone.conf  /etc/apache2/sites-available/wsgi-keystone.conf
RUN ln -s /etc/apache2/sites-available/wsgi-keystone.conf /etc/apache2/sites-enabled
RUN mkdir -p /var/www/cgi-bin/keystone
RUN  curl http://git.openstack.org/cgit/openstack/keystone/plain/httpd/keystone.py?h=stable/kilo | tee /var/www/cgi-bin/keystone/main /var/www/cgi-bin/keystone/admin
RUN chown -R keystone:keystone /var/www/cgi-bin/keystone
RUN chmod 755 /var/www/cgi-bin/keystone/*

# GLANCE
RUN apt-get install -y glance python-glanceclient
COPY conf/glance-api.conf /etc/glance/glance-api.conf
COPY conf/glance-registry.conf /etc/glance/glance-registry.conf

# NOVA
RUN apt-get install -y nova-api nova-cert nova-conductor nova-consoleauth nova-novncproxy nova-scheduler python-novaclient
COPY conf/nova.conf /etc/nova/nova.conf
 
RUN mkdir scripts
COPY scripts/* scripts/
CMD scripts/run.sh
