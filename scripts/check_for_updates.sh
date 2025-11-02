#!/bin/sh
echo "" > ~/scripts/update_checker.log
count=0
while true; do
  polybar-msg hook updates-pacman 0 && echo "$count updated the module!" >> ~/scripts/update_checker.log
  count=$(($count+1))
  sleep 1800
done

