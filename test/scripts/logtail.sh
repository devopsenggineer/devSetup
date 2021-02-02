#!/bin/bash
# Author: Syed Imran
# Date Created: 06/02/2020
# Description: This script will log only defined keywords
# Date Modified: 06/03/2020
echo Little Demo on Centralized logging

tail -fn0 /var/log/syslog | while read line
do
#echo $line | egrep -i "refused|invalid|error|exception|lost|fail|shut|offline|crit|alert|emerg"


echo $line | egrep -i "exception"
        if [ $? = 0 ]
        then
        echo $line >> /tmp/emailFiles/Exception-messages.txt
        fi
#echo $line | egrep -i "failure"
#        if [ $? = 0 ]
#        then
#        echo $line >> /tmp/emailFiles/failure-messages.txt
#        fi

echo $line | egrep -i "'java.lang.OutOfMemoryError: GC overhead limit exceeded'"
        if [ $? = 0 ]
        then
        echo $line >> /tmp/emailFiles/OutOfMemroyError-messages.txt
        SimsappID=$(sudo docker ps -q -f name=simsapp)
        sudo docker rm -f $SimsappID
        sleep 5
        NginxID=$(sudo docker ps -q -f name=web)  
        sudo docker rm -f $NginxID
        
        fi
done



echo End of Script

