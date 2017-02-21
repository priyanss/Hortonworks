#!/bin/bash

# Written by Priyan
# Aim is to start all services after cluster restart
# This script should be configured on all servers if you're not sure all the services will be up at the same time.

user=<ambari admin user>
pass=<ambari admin pass>
ambari_host=<ambari hostname/IP>
cluster=<clustername>

services=( ZOOKEEPER SERVICE2 .. <list all desired services obtained from above command separated by space> .. HDFS )
# Sleep for 150 secs to make sure ambari-agent and server comes online

sleep 150

for service in "${services[@]}"; do
        curl --silent --user $user:$pass -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"'"Starting $service via API"'"}, "ServiceInfo": {"state" : "STARTED"}}' http://$ambari_host:8080/api/v1/clusters/$cluster/services/$service
done
