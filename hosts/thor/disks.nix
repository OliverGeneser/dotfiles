{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-WD_Blue_SN580_1TB_242733801331";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              label = "boot";
              name = "ESP";
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                  "umask=0077"
                ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [
                  "-L"
                  "nixos"
                  "-f"
                ];
                postCreateHook = ''
                  mount -t btrfs /dev/disk/by-label/nixos /mnt
                  btrfs subvolume snapshot -r /mnt/root /mnt/root-blank
                  umount /mnt
                '';
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = [
                      "subvol=root"
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = [
                      "subvol=home"
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "subvol=nix"
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "/persist" = {
                    mountpoint = "/persist";
                    mountOptions = [
                      "subvol=persist"
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "/log" = {
                    mountpoint = "/var/log";
                    mountOptions = [
                      "subvol=log"
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "/swap" = {
                    mountpoint = "/swap";
                    swap.swapfile.size = "64G";
                  };
                };
              };
            };
          };
        };
      };
      disk1 = {
        device = "/dev/disk/by-id/ata-ST20000NM007D-3DJ103_WVT0XWWL";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                mountpoint = "/mnt/root/disk1";
                subvolumes = {
                  "/data" = {
                    mountpoint = "/mnt/disk1";
                    mountOptions = [ "subvol=data" ];
                  };
                  "/.snapshots" = {
                    mountpoint = "/mnt/disk1/.snapshots";
                    mountOptions = [ "subvol=.snapshots" ];
                  };
                  "/content" = {
                    mountpoint = "/mnt/snapraid-content/disk1";
                    mountOptions = [ "subvol=content" ];
                  };
                };
              };
            };
          };
        };
      };
      disk2 = {
        device = "/dev/disk/by-id/ata-HUH721212ALE601_8HJ6EGGH";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                mountpoint = "/mnt/root/disk2";
                subvolumes = {
                  "/data" = {
                    mountpoint = "/mnt/disk2";
                    mountOptions = [ "subvol=data" ];
                  };
                  "/.snapshots" = {
                    mountpoint = "/mnt/disk2/.snapshots";
                    mountOptions = [ "subvol=.snapshots" ];
                  };
                  "/content" = {
                    mountpoint = "/mnt/snapraid-content/disk2";
                    mountOptions = [ "subvol=content" ];
                  };
                };
              };
            };
          };
        };
      };
      parity1 = {
        device = "/dev/disk/by-id/ata-WDC_WUH721414ALE6L4_Y6GJ5Z5C";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/mnt/parity1";
              };
            };
          };
        };
      };
      tank0 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-WDC_WD80EMZZ-11B4FB0_WD-CA02DJSG";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "tank";
              };
            };
          };
        };
      };
      tank1 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-WDC_WD80EMZZ-11B4FB0_WD-CA059PAG";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "tank";
              };
            };
          };
        };
      };
      storage = {
        type = "filesystem";
        device = "/mnt/disk1:/mnt/disk2:/mnt/tank/fuse";
        content = {
          type = "filesystem";
          format = "fuse.mergerfs";
          mountpoint = "/mnt/storage";
          mountOptions = [
            "defaults"
            "nonempty"
            "allow_other"
            "use_ino"
            "cache.files=off"
            "moveonenospc=true"
            "category.create=epmfs"
            "dropcacheonclose=true"
            "minfreespace=250G"
            "fsname=mergerfs"
          ];
        };
      };
    };

    zpool = {
      tank = {
        type = "zpool";
        mode = "mirror";
        options = {
          ashift = "12";
          autotrim = "on";
          # Workaround: cannot import 'zroot': I/O error in disko tests
          cachefile = "none";
        };
        rootFsOptions = {
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
        };
        mountpoint = "/mnt/tank";

        postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^tank@blank$' || zfs snapshot tank@blank";

        datasets = {
          fuse = {
            type = "zfs_fs";
            mountpoint = "/mnt/tank/fuse";
            options."com.sun:auto-snapshot" = "true";
          };
        };
      };
    };
  };
  fileSystems."/persist".neededForBoot = true;
  fileSystems."/var/log".neededForBoot = true;
}
