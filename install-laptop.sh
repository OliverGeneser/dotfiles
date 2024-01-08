#!/bin/bash

# Check if yay is installed
ISyay=/sbin/yay

if [ -f "$ISyay" ]; then
    printf "\n%s - yay was located\n"
else 
    printf "\n%s - yay was NOT located\n"
    exit
fi

# TLP
yay -S tlp tlp-rdw

# Enable services
sudo systemctl enable tlp.service
sudo systemctl enable NetworkManager-dispatcher.service
sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket
