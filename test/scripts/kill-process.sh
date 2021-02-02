#!/bin/bash
# Author: Syed Imran
# Date Created: 06/04/2020
# Description: This script will helps us understand  in shell-script
# Date Modified: 06/04/2020
echo Little Demo on killing log-tail process
pwd
cd /mnt/scripts/
pwd
logId=$(ps -ef | grep logtail | awk '{print $2}')
echo $logId
kill -9 $logId
ps -ef | grep logtail 

rm -rf  simsapp-server-live-logs.txt

nohup ./logtail  > simsapp-server-live-logs.txt &

echo $?

echo
ps -ef | grep logtail
echo

dstatsId=$(ps -ef | grep docker-stats | awk '{print $2}')
echo $dstatsId
kill -9 $dstatsId
ps -ef | grep docker-stats 

rm -rf  /tmp/emailFiles/SIMSAPP-Docker-Resources-Usage-Stats.txt

nohup ./docker-stats.sh  >> /tmp/emailFiles/SIMSAPP-Docker-Resources-Usage-Stats.txt &

echo $?

echo
ps -ef | grep docker-stats
echo


echo End of Script

