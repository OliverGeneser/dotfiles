# Geneser Nix Config

## Install

```
sudo nix run github:nix-community/disko \
        --extra-experimental-features "nix-command flakes" \
        --no-write-lock-file \
        -- \
        --mode zap_create_mount \
        "$HOME/dotfiles/hosts/$TARGET_HOST/disks.nix"
```
```
sudo btrfs subvolume snapshot -r /mnt/ /mnt/root-blank
```
```
sudo nixos-install --no-root-password --flake "$HOME/dotfiles#$TARGET_HOST"
```

## Update
```nix develop```
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
