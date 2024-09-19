#!/bin/bash

# Infinite demo of writing plasm pattern to RGB LED stripe
#
# ^Z stops script, ^C won't work
#
# I'm using this script as a background task while I'm coding.

echo "Infinite demo of writing plasm pattern to RGB LED stripe."
echo
echo "Press ^Z to terminate this script."
echo
echo "(That was the last notification.)"
echo
echo "---"

while true
do
  lua MakePlasm.lua
  lua SendData.lua
  sleep 5
done

# 2024-09-18
