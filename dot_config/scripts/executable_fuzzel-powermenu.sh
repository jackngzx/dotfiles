#!/bin/bash

SELECTION="$(printf "1 - Lock\n2 - Suspend\n3 - Log out\n4 - Reboot\n5 - Reboot to UEFI\n6 - Shutdown" | fuzzel --dmenu -l 7 -p "Power Menu: ")"

case $SELECTION in
*"Lock")
  swaylock --clock --indicator --screenshots --effect-scale 0.4 --effect-vignette 0.2:0.5 --effect-blur 4x2
  ;;
*"Suspend")
  swaylock --daemonize && systemctl suspend
  ;;
*"Log out")
  niri msg action quit
  ;;
*"Reboot")
  systemctl reboot
  ;;
*"Reboot to UEFI")
  systemctl reboot --firmware-setup
  ;;
*"Shutdown")
  systemctl poweroff
  ;;
esac
