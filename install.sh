#!/bin/bash

# Check if yay is installed
ISyay=/sbin/yay

if [ -f "$ISyay" ]; then
    printf "\n%s - yay was located\n"
else 
    printf "\n%s - yay was NOT located\n"
    exit
fi

# Tools
yay -S --answerdiff None --answerclean None util-linux git base-devel rustup neofetch

# Git packages
yay -S --answerdiff None --answerclean None sway-audio-idle-inhibit-git

# Hyprland stuff
yay -S --answerdiff None --answerclean None hyprland-git polkit-kde-agent xdg-desktop-portal-gtk xdg-desktop-portal-hyprland-git kitty tmux hyprpicker-git eww-wayland dunst tofi eww-wayland nwg-look-bin wlogout

# Must haves
yay -S --answerdiff None --answerclean None qt5-wayland qt6-wayland cliphist wl-clip-persist viewnior thunar thunar-archive-plugin thunar-volman file-roller gvfs ffmpeg ffmpegthumbnailer brightnessctl sddm-git qt5-graphicaleffects qt5-svg qt5-quickcontrols2 swaylock-effects-git swayidle swaybg ufw bluez blueman webcord networkmanager network-manager-applet fzf

# Networking
yay -S --answerdiff None --answerclean None net-tools

# Audio
yay -S --answerdiff None --answerclean None pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber alsa-plugins alsa-utils pavucontrol pamixer easyeffects

# Themes
yay -S --answerdiff None --answerclean None catppuccin-gtk-theme-mocha catppuccin-cursors-mocha colloid-gtk-theme papirus-icon-theme nwg-look-bin
git clone https://github.com/catppuccin/sddm
sudo mv ./sddm/src/catppuccin-mocha/ /usr/share/sddm/themes/
sudo cp ./sddm.conf /etc/sddm.conf
curl https://raw.githubusercontent.com/catppuccin/tofi/main/catppuccin-mocha >>~/.config/tofi/config

# Font
mkdir -p /usr/share/fonts/nerd-fonts
curl https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip -L -o /usr/share/fonts/nerd-fonts/FiraCode.zip
unzip /usr/share/fonts/nerd-fonts/FiraCode.zip -d /usr/share/fonts/nerd-fonts
rm /usr/share/fonts/nerd-fonts/FiraCode.zip
fc-cache -rv

yay -S --answerdiff None --answerclean None noto-fonts ttf-ms-fonts

# Apps
yay -S --answerdiff None --answerclean None firefox vlc webcord

# Tools
yay -S --answerdiff None --answerclean None neovim ripgrep nvm openssh libfido2

yay -S --answerdiff None --answerclean None docker docker-compose
sudo groupadd docker
sudo usermod -aG docker $USER

# Zsh
yay -S --answerdiff None --answerclean None zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
chsh -s $(which zsh)

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

git clone https://github.com/catppuccin/zsh-syntax-highlighting.git
mkdir -p ~/.zsh
cp ./zsh-syntax-highlighting/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh ~/.zsh/

# Secure
sudo ufw default deny incoming
sudo ufw enable

# Enable services
sudo systemctl enable sddm.service ufw bluetooth docker.service containerd.service
