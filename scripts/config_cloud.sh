export OS_TOKEN=couchbase
export OS_URL=http://controller:35357/v2.0
source scripts/admin-openrc.sh

# identity service
openstack service create --name keystone --description "OpenStack Identity" identity
openstack endpoint create \
  --publicurl http://controller:5000/v2.0 \
  --internalurl http://controller:5000/v2.0 \
  --adminurl http://controller:35357/v2.0 \
  --region RegionOne \
  identity

# add projects, users, roles
openstack project create --description "Admin Project" admin
openstack user create --password couchbase admin
openstack role create admin
openstack role add --project admin --user admin admin

openstack project create --description "Service Project" service
openstack project create --description "Demo Project" demo
openstack user create --password demo demo

openstack role create user
openstack role add --project demo --user demo user


# glance
openstack user create --password couchbase glance
openstack role add --project service --user glance admin
openstack service create --name glance --description "OpenStack Image service" image

openstack endpoint create \
  --publicurl http://controller:9292 \
  --internalurl http://controller:9292 \
  --adminurl http://controller:9292 \
  --region RegionOne \
  image


# nova
openstack user create --password couchbase nova
openstack role add --project service --user nova admin
openstack service create --name nova --description "OpenStack Compute" compute
 openstack endpoint create \
  --publicurl http://controller:8774/v2/%\(tenant_id\)s \
  --internalurl http://controller:8774/v2/%\(tenant_id\)s \
  --adminurl http://controller:8774/v2/%\(tenant_id\)s \
  --region RegionOne \
  compute

