#!/bin/bash

for element in `ls  | grep kg169 | awk -F " " '{print $0}'`;do
    str=${element%%.*}
    filename="$str.$1.conf"
    cp $element $filename -rf
    sed -i "s#kg169.com#$1#" $filename
    #echo "$str.$1.conf"
done
