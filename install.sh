#!/bin/bash

# Tools
yay -S --answerdiff None --answerclean None git base-devel rustup

# Hyprland stuff
yay -S --answerdiff None --answerclean None hyprland-git polkit-kde-agent xdg-desktop-portal-hyprland-git kitty hyprpicker-git eww-wayland dunst tofi eww-wayland nwg-look-bin wlogout

# Must haves
yay -S --answerdiff None --answerclean None qt5-wayland qt6-wayland cliphist wl-clip-persist viewnior thunar thunar-archive-plugin thunar-volman file-roller gvfs ffmpeg ffmpegthumbnailer brightnessctl sddm-git qt5-graphicaleffects qt5-svg qt5-quickcontrols2 swaylock-effects-git ufw bluez blueman webcord

# Audio
yay -S --answerdiff None --answerclean None pipewire wireplumber

# Themes
yay -S --answerdiff None --answerclean None catppuccin-gtk-theme-mocha catppuccin-cursors-mocha colloid-gtk-theme papirus-icon-theme nwg-look-bin
git clone https://github.com/catppuccin/sddm
sudo mv ./sddm/src/catppuccin-mocha/ /usr/share/sddm/themes/
sudo cp ./sddm.conf /etc/sddm.conf
curl https://raw.githubusercontent.com/catppuccin/tofi/main/catppuccin-mocha >> ~/.config/tofi/config

# Font
mkdir -p ~/.local/share/fonts/nerd-fonts
curl https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip -L -o FiraCode.zip 
mv FiraCode.zip ~/.local/share/fonts/nerd-fonts
unzip ~/.local/share/fonts/nerd-fonts/FiraCode.zip -d ~/.local/share/fonts/nerd-fonts

# Apps
yay -S --answerdiff None --answerclean None neovim firefox vlc

# Secure
sudo ufw default deny incoming
sudo ufw enable

# Enable services
sudo systemctl enable sddm.service ufw bluetooth
