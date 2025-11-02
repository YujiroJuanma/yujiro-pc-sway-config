#!/bin/zsh
#Script to find amount of desktops and print them
#
workspace=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).name')

workspaces=$(i3-msg -t get_workspaces | jq -r '.[].name')
works=(${(f)workspaces})
works=(${(@n)works})
for VAR in "${works[@]}"
do
      if [[ $VAR == $workspace ]]; then
            echo "@$VAR"" | "
      else
            echo -n "$VAR"" | "
      fi
done

