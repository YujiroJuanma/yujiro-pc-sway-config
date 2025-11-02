#!/bin/bash

notifications=$(swaync-client -c)

if [ "$notifications" -gt 0 ]; then
	echo " $notifications"
else
	echo "󰂚  "
fi
