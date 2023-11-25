# dotfiles
Dotfiles backup

<h2>Restore backup</h2>

### Init pacman
```bash
sudo pacman-key --init
```
```bash
sudo pacman-key --populate archlinux
```

### Download and make the files exec
```bash
git clone https://github.com/olivergeneser/dotfiles && cd dotfiles && sudo chmod +x *.sh
```

### Install all the essentials
```bash
./install-yay.sh
```
```bash
./install.sh
```

### Copy relevant files
```bash
cp .config /.config
```

### Dev tools
```bash
./install-dev.sh
```

### Laptop
```bash
./install-laptop.sh
```

### Nvidia 
```bash
./install-nvidia.sh
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

