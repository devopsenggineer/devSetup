#!/bin/bash
# Author: Syed Imran
# Date Created: 06/04/2020
# Description: This script will helps us understand  in shell-script
# Date Modified: 06/04/2020
echo Little Demo on 

cpuuse=$(cat /proc/loadavg | awk '{print $1}')
echo $cpuuse
if [ "$cpuuse" > 90.00 ]; 
then

    SUBJECT="ATTENTION: CPU Load Is High on $(hostname) at $(date)"

    MESSAGE="/tmp/Mail.txt"

    TO="syedimran.ec@gmail.com,devopsenggineer@gmail.com"

    echo "CPU Current Usage is: $cpuuse%" >> $MESSAGE

    echo "" >> $MESSAGE

    echo "+------------------------------------------------------------------+" >> $MESSAGE

    echo "Top CPU Process Using top command" >> $MESSAGE

    echo "+------------------------------------------------------------------+" >> $MESSAGE

    echo "$(top -bn1 | head -20)" >> $MESSAGE

    echo "" >> $MESSAGE

    echo "+------------------------------------------------------------------+" >> $MESSAGE

    echo "Top CPU Process Using ps command" >> $MESSAGE

    echo "+------------------------------------------------------------------+" >> $MESSAGE

    echo "$(ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10)" >> $MESSAGE

    mail -s "$SUBJECT" "$TO" < $MESSAGE

    rm -rf /tmp/Mail.txt

else
    echo "No thing to mail, Thank you" 
fi



echo End of Script

