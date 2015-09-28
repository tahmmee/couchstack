ip=`cat /etc/hosts  | grep controller | awk '{print $1}'`
grep -R CONTROLLER_IP /etc/*/ | awk -F ':' '{print $1}' | xargs -I '{}' sed -i "s/CONTROLLER_IP/$ip/g" '{}'

echo 'NODE_IP_ADDRESS='$ip >> /etc/rabbitmq/rabbitmq-env.conf

echo 'ServerName controller' >> /etc/apache2/apache2.conf

