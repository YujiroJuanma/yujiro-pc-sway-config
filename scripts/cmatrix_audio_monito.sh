#!/bin/bash

# A script to run or kill cmatrix based on active PulseAudio streams.

while true; do
  # Check if any audio sinks are active
  if pactl list sink-inputs | grep -q "Sink Input"; then
    # If sound is playing and cmatrix is not running, start it
    if ! pgrep -x "cmatrix" > /dev/null; then
      cmatrix -b &
    fi
  else
    # If no sound is playing and cmatrix is running, kill it
    if pgrep -x "cmatrix" > /dev/null; then
      pkill -x "cmatrix"
    fi
  fi

  # Wait for 1 second before checking again to reduce CPU usage
  sleep 1
done
