#!/bin/bash

# TLP
yay -S tlp tlp-rdw

# Enable services
sudo systemctl enable tlp.service
sudo systemctl enable NetworkManager-dispatcher.service
sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket
