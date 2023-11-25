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
cp -r .config/* ~/.config
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
https://wiki.hyprland.org/Nvidia/
```bash
./install-nvidia.sh

nvidia_drm.modeset=1 to the end of /boot/loader/entries/arch.conf
/etc/mkinitcpio.conf add nvidia nvidia_modeset nvidia_uvm nvidia_drm to your MODULES
run # mkinitcpio --config /etc/mkinitcpio.conf --generate /boot/initramfs-custom.img
add a new line to /etc/modprobe.d/nvidia.conf (make it if it does not exist) and add the line options nvidia-drm modeset=1

Export these variables in your hyprland config:

env = LIBVA_DRIVER_NAME,nvidia
env = XDG_SESSION_TYPE,wayland
env = GBM_BACKEND,nvidia-drm
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
env = WLR_NO_HARDWARE_CURSORS,1

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

