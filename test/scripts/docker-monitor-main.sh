#!/bin/bash

# This script is used to complete the output of the docker stats command.
# The docker stats command does not compute the total amount of resources (RAM or CPU)

# Get the total amount of RAM, assumes there are at least 1024*1024 KiB, therefore > 1 GiB
docker stats | while read line

do
  
   HOST_MEM_TOTAL=$(grep MemTotal /proc/meminfo | awk '{print $2/1024/1024}')
   #echo "HOST TOTAL Memory: $HOST_MEM_TOTAL"
   oldifs=IFS
   IFS=;
   dStats=$(docker stats --no-stream --format "table {{.MemPerc}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.Name}}\t{{.ID}}" | sed -n '1!p')
   #dStats=$( docker stats --no-stream --format "table {{.MemPerc}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.Name}}\t{{.ID}}")

   SUM_RAM=`echo $dStats | tail -n +2 | sed "s/%//g" | awk '{s+=$1} END {print s}'`
   SUM_CPU=`echo $dStats | tail -n +2 | sed "s/%//g" | awk '{s+=$2} END {print s}'`
   SUM_RAM_QUANTITY=`LC_NUMERIC=C printf %.2f $(echo "$SUM_RAM*$HOST_MEM_TOTAL*0.01" | bc)`


   # Output the result
   echo "########################################### Start of Resources Output ##############################################" >> /tmp/emailFiles/SIMSAPP-Docker-Resources-Usage-Stats.txt
   echo " " >> /tmp/emailFiles/SIMSAPP-Docker-Resources-Usage-Stats.txt
   dat=$(date)
   echo "Present date & Time is: $dat" >> /tmp/emailFiles/SIMSAPP-Docker-Resources-Usage-Stats.txt

   #IFS=$olifs
   #echo "MEM %               CPU %               MEM USAGE / LIMIT     NAME                                               CONTAINER ID" >> /tmp/emailFiles/SIMSAPP-Docker-Resources-Usage-Stats.txt
   echo "MEM %               CPU %               MEM USAGE / LIMIT     NAME                                      CONTAINER ID" >> /tmp/emailFiles/SIMSAPP-Docker-Resources-Usage-Stats.txt
   IFS=$'\r\n' GLOBIGNORE='*'
   for i in  $dStats
   do
      cpuPerc=$(echo $i | awk '{print $2}')
      memPerc=$(echo $i | awk '{print $1}')
      cpuPerc=${cpuPerc%"%"}
      cpuPerc=${cpuPerc/.*}
      memPerc=${memPerc%"%"}
      memPerc=${memPerc/.*}
      #if [ $cpuPerc -ge 100 ] && [ $memPerc -ge 35  ]
      if [ $cpuPerc -ge 100 ] || [ $memPerc -ge 50  ]
      then
#         IFS=$oldifs
         echo $i >> /tmp/emailFiles/SIMSAPP-Docker-Resources-Usage-Stats.txt
      else
         a="hello"
      fi
   done
#   IFS=$oldifs
   SUM_RAM=${SUM_RAM/.*}
   SUM_CPU=${SUM_CPU/.*}
   if [ $SUM_RAM -ge 70 ] && [ $SUM_CPU -ge 100  ]
   #if [ $SUM_RAM -ge 70 ] || [ $SUM_CPU -ge 100  ]
      then
         echo " " >>/tmp/emailFiles/SIMSAPP-Docker-Resources-Usage-Stats.txt
         echo "Total-MEMORY-Usage Total-CPU-Usage      Used-MEM / Total-MEM" >> /tmp/emailFiles/SIMSAPP-Docker-Resources-Usage-Stats.txt
         #echo -e "${SUM_RAM}%\t\t\t${SUM_CPU}%\t\t${SUM_RAM_QUANTITY}GiB / ${HOST_MEM_TOTAL}GiB\tTOTAL" >> /tmp/emailFiles/SIMSAPP-Docker-Resources-Usage-Stats.txt
         echo -e "${SUM_RAM}%\t\t\t${SUM_CPU}%\t\t${SUM_RAM_QUANTITY}GiB / ${HOST_MEM_TOTAL}GiB" >> /tmp/emailFiles/SIMSAPP-Docker-Resources-Usage-Stats.txt
         echo " ">>/tmp/emailFiles/SIMSAPP-Docker-Resources-Usage-Stats.txt
   fi
   
   disk_usage=$(df -hT | grep ext4 | awk '{print $6}')
   disk_usage=${disk_usage%"%"}
#   disk_usage=${disk_usage/.*} 
   if [ $disk_usage -ge 90  ]
      then
         #echo "Filesystem      Size  Used Avail Use% Mounted on" >>/tmp/emailFiles/SIMSAPP-Docker-Resources-Usage-Stats.txt
         echo "Filesystem     Type      Size  Used Avail Use% Mounted on" >> /tmp/emailFiles/SIMSAPP-Docker-Resources-Usage-Stats.txt
         df -hT | grep ext4 >> /tmp/emailFiles/SIMSAPP-Docker-Resources-Usage-Stats.txt
         echo " "
         #cat /tmp/emailFiles/SIMSAPP-Docker-Resources-Usage-Stats.txt
   fi
   
   echo "########################################### End of Resources Output ################################################" >> /tmp/emailFiles/SIMSAPP-Docker-Resources-Usage-Stats.txt
   echo " " >> /tmp/emailFiles/SIMSAPP-Docker-Resources-Usage-Stats.txt

done

