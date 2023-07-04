# dotfiles
Dotfiles backup

<h2>Restore backup</h2>

### Installes all packages from AUR and deploys config files
```bash
git clone --bare git@github.com:olivergeneser/dotfiles.git dotfiles
git --git-dir=$HOME/dotfiles --work-tree=$HOME config --local core.worktree $HOME

# install yay
pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd .. && rm -rf yay
yay -Y --gendb

# install packages
mkdir -p /tmp/yay; yay -S --builddir /tmp/yay --needed --nodiffmenu --noeditmenu - < pkglist-intel.txt

# add firewall rule
sudo ufw default deny incoming
sudo ufw allow syncthing
sudo ufw enable

# enable services
sudo systemctl enable --now input-remapper docker tlp ufw bluetooth
```

### Restores GTK options
```bash
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
gsettings set org.gtk.Settings.FileChooser startup-mode cwd
gsettings set org.gtk.gtk4.Settings.FileChooser startup-mode cwd
# cursor and icon themes
gsettings set org.gnome.desktop.interface cursor-theme 'bloom'
gsettings set org.gnome.desktop.interface icon-theme 'bloom-classic'
```

### Neovim plugins and dependencies
```bash
sh -c "$(wget -O- https://raw.githubusercontent.com/olivergeneser/dotfiles/master/fetch-nvim-conf.sh)"
```
