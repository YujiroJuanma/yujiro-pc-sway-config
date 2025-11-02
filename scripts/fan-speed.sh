#!/bin/sh

speed=$(sensors | grep 3300 | awk '{print $2; exit}')

if [ "$speed" != "" ]; then
    speed_round=$(echo "$speed" | bc -l | LANG=C xargs printf "%.1f\n")
    echo " $speed_round"
else
   echo "#"
fi
