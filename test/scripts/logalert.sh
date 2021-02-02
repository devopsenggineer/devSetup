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


IT="shaiksazidh@gmail.com,devopsenggineer@gmail.com,syedimran.ec@gmail.com"
if [ -s /tmp/Exception-messages.txt ]
        then
        cat /tmp/Exception-messages.txt | sort | uniq | mail -s "Simsapp Server Exception Message" -A "/tmp/Exception-messages.txt" $IT
        rm -rf  /tmp/Exception-messages.txt
        else
        echo "Nothing to Email"
        fi


if [ -s /tmp/java.lang.OutOfMemroyError-messages.txt ]
        then
        cat /tmp/java.lang.OutOfMemroyError-messages.txt | sort | uniq | mail -s "Simsapp Server java.lang.OutOfMemroyError " -A "/tmp/java.lang.OutOfMemroyError-messages.txt" $IT
        rm -rf  /tmp/java.lang.OutOfMemroyError-messages.txt
        else
        echo "Nothing to Email"
        fi


echo End of Script

