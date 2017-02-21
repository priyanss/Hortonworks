#!/bin/bash

# Written by Priyan S on 20-02-2017
# This is to kill all existing YARN jobs, checkpoint HDFS and stop all services for a graceful cluster shutdown.

user=<ambari admin user>
pass=<ambari admin pass>
ambari_host=<ambari hostname/IP>
cluster=<clustername>
bkup_pg=<backup location where pgsql dumps can be stored>

# Kill all running Apps

> /tmp/.cur_apps
su - hdfs -c "yarn application -list 2> /dev/null" | grep application_ | awk {'print $1'} > /tmp/.cur_apps

wc=`cat /tmp/.cur_apps | wc -l`
if [ $wc -gt 0  ];then
        for i in `cat /tmp/.cur_apps`; do
                su - hdfs -c "yarn application -kill $i"
        done
fi

# Checkpoint HDFS

su - hdfs -c "hdfs dfsadmin -safemode enter"
su - hdfs -c "hdfs dfsadmin -saveNamespace"
su - hdfs -c "hdfs dfsadmin -safemode leave"

# Stop all services

# Use the below command to list all services managed by Ambari
# curl --silent --user $user:$pass -H 'X-Requested-By: ambari' -X GET http://$ambari_host:8080/api/v1/clusters/$cluster/services/$service

services=( AMBARI_INFRA AMBARI_METRICS .. <list all desired services obtained from above command separated by space> .. HDFS )

for service in "${services[@]}"; do
        
        curl --silent --user $user:$pass -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"'"Stopping $service via API"'"}, "ServiceInfo": {"state" : "INSTALLED"}}' http://$ambari_host:8080/api/v1/clusters/$cluster/services/$service
done

su - postgres -c "pg_dumpall > $bkup_pg/pg_all_dbs_`date +%F-%H_%M_%S`.sql"
