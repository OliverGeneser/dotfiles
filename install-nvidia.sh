#!/bin/bash
# https://wiki.hyprland.org/Nvidia/

# Check if yay is installed
ISyay=/sbin/yay

if [ -f "$ISyay" ]; then
    printf "\n%s - yay was located\n"
else 
    printf "\n%s - yay was NOT located\n"
    exit
fi

# Tools
yay -S hyprland-git nvidia-dkms qt5-wayland qt5ct libva libva-nvidia-driver-git linux-headers

sudo systemctl enable nvidia-suspend.service
sudo systemctl enable nvidia-hibernate.service
sudo systemctl enable nvidia-resume.service

# nvidia.NVreg_PreserveVideoMemoryAllocations=1
