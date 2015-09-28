# mysql
service mysql start
mysqladmin -u root password couchbase
mysql  -pcouchbase < scripts/init_db.sql
service mysql restart

# rabbitmq
service rabbitmq-server start
rabbitmqctl add_user openstack couchbase 
rabbitmqctl set_permissions openstack ".*" ".*" ".*"

# keystone
sh -c "keystone-manage db_sync" keystone
rm -f /var/lib/keystone/keystone.db

# glance
sh -c "glance-manage db_sync" glance
rm -f /var/lib/glance/glance.sqlite

# nova
sh -c "nova-manage db sync" nova
rm -f /var/lib/nova/nova.sqlite

