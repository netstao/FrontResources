#!/bin/bash

for element in `ls /wwwlog/cli.newxls.com/log  | awk -F " " '{print $0}'`;do
    str_last=${element%%.*}
    str_1=${element%%-*}
    buildPah="/data_log/logs/$str_1"
    day=`date +"%Y-%m-%d"`

    subIndex=`awk 'BEGIN{print match("'$element'","'$day'")}'`



    if [ ! -d $buildPath ]; then  
        mkdir $buildPath 
        echo "$subIndex-day"
    fi

    echo "$subIndex-day"

    

    if [ $subIndex -eq 0 ]; then
    	echo "/wwwlog/log/$element   $buildPah/$element"
    	 mv /wwwlog/log/$element "$buildPah/$element"
    fi
    
    

done
