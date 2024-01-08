#!/bin/sh
swayidle -w timeout 120 'hyprctl dispatch dpms off' \
	resume 'hyprctl dispatch dpms on' \
    timeout 300 'swaylock -f -c ~/.config/swaylock/config' \
    before-sleep 'swaylock -f -c ~/.config/swaylock/config' &