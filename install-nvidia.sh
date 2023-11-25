#!/bin/bash
# https://wiki.hyprland.org/Nvidia/

# Tools
yay -S hyprland-nvidia-git nvidia-dkms qt5-wayland qt5ct libva libva-nvidia-driver-git linux-headers

sudo systemctl enable nvidia-suspend.service
sudo systemctl enable nvidia-hibernate.service
sudo systemctl enable nvidia-resume.service

# nvidia.NVreg_PreserveVideoMemoryAllocations=1
