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
sudo nixos-install --flake "$HOME/dotfiles#$TARGET_HOST"
```
