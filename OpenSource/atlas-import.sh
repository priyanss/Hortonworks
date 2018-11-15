#!/bin/bash

# Author : Priyan S
# Purpose : Run hive-import.sh script as cron job and send status message

AMBARI_USER=admin
PASSWD=temp-pass

export HADOOP_CLASSPATH=$(hcat -classpath):`hadoop classpath`
su - atlas -c '/usr/bin/kinit -kt /etc/security/keytabs/atlas.service.keytab atlas/<hostname>@DOMAIN'
su - atlas -c 'sh /usr/hdp/current/atlas-client/hook-bin/import-hive.sh'

today=`date +%F`
count=`tail -n 4 /usr/hdp/current/atlas-client/logs/import-hive.log | grep $today |egrep "Successfully imported all|Shutdown of Atlas Hive Hook" | wc -l`
if [ $count -eq 3 ]; then
    MSG="Atlas Hive Import looks Successful"
    /usr/bin/curl --silent --user $AMBARI_USER:$PASSWD -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"'"Stopping ATLAS via API after import"'"}, "ServiceInfo": {"state" : "INSTALLED"}}' http://<ambari_hostname>:8080/api/v1/clusters/<cluster_name>/services/ATLAS
    sleep 30s
    /usr/bin/curl --silent --user $AMBARI_USER:$PASSWD -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"'"Starting ATLAS via API after import"'"}, "ServiceInfo": {"state" : "STARTED"}}' http://<ambari_hostname>:8080/api/v1/clusters/<cluster_name>/services/ATLAS
else
   MSG="Atlas Hive Import Failed"
fi

(echo EHLO localhost
echo MAIL FROM: atlas-import@mail_domain
echo RCPT TO: <youremail_id>
echo "DATA
From: atlas-import@mail_domain
To: <youremail_id>
Subject: $MSG
 
$MSG"
echo '.'
echo QUIT) | nc <smtp_server_ip> 25