# Geneser Nix Config

## Install

```
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount ./hosts/X/disks.nix
```

```
sudo nixos-install --no-root-password --flake "$HOME/dotfiles#$TARGET_HOST"
```

## Update

```
nix develop
```

### Update system

```
nh os switch
```

### Update Home

```
nh home switch
```

### Deploy to remote server

```
deploy .#NAME --hostname 10.0.0.X --ssh-user nixos --skip-checks
```

## Recover

```
sudo cryptsetup open /dev/sdX2 cryptroot

sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode mount /tmp/disk-config.nix

sudo nixos-install --no-root-password --flake "$HOME/dotfiles#$TARGET_HOST"


sudo mkdir -p /mnt/{dev,proc,sys,boot}
sudo mount -o bind /dev /mnt/dev
sudo mount -o bind /proc /mnt/proc
sudo mount -o bind /sys /mnt/sys
sudo chroot /mnt /nix/var/nix/profiles/system/activate
sudo chroot /mnt /run/current-system/sw/bin/bash

sudo mount /dev/vda1 /mnt/boot
sudo cryptsetup open /dev/vda3 cryptroot
sudo mount /dev/mapper/cryptroot /mnt/

sudo nixos-enter


```

### Build Raspberry pi

```
nix build .#sd-aarch64Configurations.tunnelboy
```
