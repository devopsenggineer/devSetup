#!/bin/bash
#set -xv
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
dat=$(date)
echo "Present date & Time is: $dat" >> stats.txt

IFS=$olifs
echo "MEM %               CPU %               MEM USAGE / LIMIT     NAME                                               CONTAINER ID" >> stats.txt
IFS=$'\r\n' GLOBIGNORE='*'
for i in  $dStats
do
   cpuPerc=$(echo $i | awk '{print $2}')
   memPerc=$(echo $i | awk '{print $1}')
   cpuPerc=${cpuPerc%"%"}
   cpuPerc=${cpuPerc/.*}
   memPerc=${memPerc%"%"}
   memPerc=${memPerc/.*}
   if [ $cpuPerc -ge 1 ] && [ $memPerc -ge 1  ]
#   if [ $cpuPerc -ge 1 ] || [ $memPerc -ge 1  ]
    then
       echo $i >> stats.txt
#    else
#       echo " "
   fi
done

#IFS=$oldifs
SUM_RAM=${SUM_RAM/.*}
SUM_CPU=${SUM_CPU/.*}
#echo $SUM_RAM
#echo $SUM_CPU
#if [ $SUM_RAM -ge 2 ] && [ $SUM_CPU -ge 10  ]
if [ $SUM_RAM -ge 2 ] || [ $SUM_CPU -ge 10  ]
   then
      echo " " >>stats.txt
      echo "Total-MEMORY-Usage Total-CPU-Usage      Used-MEM / Total-MEM" >> stats.txt
      #echo -e "${SUM_RAM}%\t\t\t${SUM_CPU}%\t\t${SUM_RAM_QUANTITY}GiB / ${HOST_MEM_TOTAL}GiB\tTOTAL" >> stats.txt
      echo -e "${SUM_RAM}%\t\t\t${SUM_CPU}%\t\t${SUM_RAM_QUANTITY}GiB / ${HOST_MEM_TOTAL}GiB" >> stats.txt
      echo " ">>stats.txt
#    else
#       echo " "
fi

disk3_usage=$(df -kh | grep sda3 | awk '{print $5}')
#echo "$disk3_usage"
disk3_usage=${disk3_usage%"%"}
#echo "$disk3_usage"
#disk3_usage=${disk5_usage/.*}
if [ $disk3_usage -ge 50  ]
   then
#     echo " "
      echo "Filesystem      Size  Used Avail Use% Mounted on" >>stats.txt
      df -kh | grep sda3 >> stats.txt
      echo " " >> stats.txt
#   else
#      echo " "
fi  


disk5_usage=$(df -kh | grep sda5 | awk '{print $5}')
disk5_usage=${disk5_usage%"%"}
#echo "disk3_usage"
#disk5_usage=${disk5_usage/.*}
if [ $disk5_usage -ge 60  ]
   then
#     echo " "
      echo "Filesystem      Size  Used Avail Use% Mounted on" >>stats.txt
      df -kh | grep sda5 >> stats.txt
      echo " " >> stats.txt
#   else
#      echo " "
fi  

cat stats.txt

