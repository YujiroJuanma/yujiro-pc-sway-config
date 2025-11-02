#!/bin/zsh

temp_in_mdc=$(cat /sys/class/drm/card1/device/hwmon/hwmon3/temp2_input)
temp=$(($temp_in_mdc / 1000))
echo "GPU: $temp"
