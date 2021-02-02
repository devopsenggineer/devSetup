#!/bin/bash
# Author: Syed Imran
# Date Created: 06/02/2020
# Description: This script will send an email to admin
# Date Modified: 06/02/2020
echo Little Demo on  Log-Alert through email

#tail -fn0 /var/log/syslog | while read line
#do
#echo $line | egrep -i "refused|invalid|error|fail|lost|shut|down|offline"
#        if [ $? = 0 ]
#        then
#        echo $line >> /tmp/filtered-messages
#        fi
#done


#IT="shaiksazidh@gmail.com,devopsenggineer@gmail.com"
IT="shaiksazidh@gmail.com,syedimran.ec@gmail.com,devopsenggineer@gmail.com"
#IT="devopsenggineer@gmail.com"
status=$(curl -Is https://simsapp.co.uk/ | head -n 1 | awk '{print $2}')
echo $status
echo
if [ $status -eq 504 ]
        then
        cat /tmp/Server-Status.txt | sort | uniq | mail -s "Simsapp Server Status" -A "/tmp/Server-Status.txt" $IT
#        rm -rf  /tmp/filtered-messages.txt
        SimsappID=$(sudo docker ps -q -f name=simsapp)
        sudo docker rm -f $SimsappID
        sleep 5
        NginxID=$(sudo docker ps -q -f name=web)  
        sudo docker rm -f $NginxID

        else
        echo "Nothing to Email"
        fi

echo End of Script

