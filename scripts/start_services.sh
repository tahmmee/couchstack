# edit confs
ip=`cat /etc/hosts  | grep controller | awk '{print $1}'`
grep -R CONTROLLER_IP /etc/*/ | awk -F ':' '{print $1}' | xargs -I '{}' sed -i "s/CONTROLLER_IP/$ip/g" '{}'

# dep services
/etc/init.d/memcached start
/etc/init.d/mysql start
/etc/init.d/rabbitmq-server start
service apache2 start

#glance
service glance-registry start
service glance-api start

#nova
service nova-api start
service nova-cert start
service nova-consoleauth start
service nova-scheduler start
service nova-conductor start
service nova-novncproxy start



