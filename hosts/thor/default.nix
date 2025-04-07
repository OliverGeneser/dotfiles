{
  pkgs,
  self,
  inputs,
  lib,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disks.nix
  ];

  config = {
    custom = {
      user.name = "nixos";
      services = {
        postgresql = {
          databases = ["immich"];
          backupLocation = "/mnt/storage/vault/postgresql";
        };
      };
    };

    boot = {
      kernelPackages = lib.mkForce pkgs.linuxPackages_6_13;
      kernelModules = ["zfs"];
      supportedFilesystems = lib.mkForce ["btrfs" "zfs"];
      resumeDevice = "/dev/disk/by-label/nixos";
      kernelParams = [
        "resume_offset=533760"
      ];

      zfs = {
        package = pkgs.zfs_2_3;
        forceImportAll = false;
        forceImportRoot = false;
      };
    };

    environment = {
      # nh default flake
      variables.NH_FLAKE = "/home/nixos/dotfiles";

      systemPackages = with pkgs; [
        nfs-utils
        xfsprogs
        e2fsprogs
        dnsutils
        smartmontools
        git
        pciutils
        mergerfs
        mergerfs-tools
        self.packages.${pkgs.system}.snapraid-btrfs
        self.packages.${pkgs.system}.snapraid-btrfs-runner
      ];
    };

    networking = {
      hostName = "thor";
      nftables.enable = true;
      firewall = {
        allowedTCPPorts = [80 443 8173 8384 8090 22000];
        allowedUDPPorts = [80 443 22000 21027];
      };
    };

    security.tpm2.enable = true;

    services = {
      # for SSD/NVME
      fstrim.enable = true;

      getty.autologinUser = "nixos";

      zfs = {
        trim.enable = true;
        trim.interval = "weekly";

        autoScrub.enable = true;
        autoScrub.pools = ["tank"];
        autoScrub.interval = "weekly";
      };

      snapraid = {
        enable = true;
        dataDisks = {
          d1 = "/mnt/disk1";
          d2 = "/mnt/disk2";
        };
        contentFiles = [
          "/persist/var/snapraid.content"
          "/mnt/snapraid-content/disk1/snapraid.content"
          "/mnt/snapraid-content/disk2/snapraid.content"
        ];
        parityFiles = [
          "/mnt/parity1/snapraid.parity"
        ];
        exclude = [
          "*.unrecoverable"
          "/tmp/"
          "/lost+found/"
          "downloads/"
          "appdata/"
          "*.!sync"
          "/.snapshots/"
        ];
        sync.interval = "";
        scrub = {
          interval = "";
        };
      };

      snapper = {
        configs = {
          d1 = {
            SUBVOLUME = "/mnt/disk1";
            ALLOW_GROUPS = ["wheel"];
            SYNC_ACL = true;
          };
          d2 = {
            SUBVOLUME = "/mnt/disk2";
            ALLOW_GROUPS = ["wheel"];
            SYNC_ACL = true;
          };
        };
      };
    };

    systemd = {
      services = {
        snapraid-btrfs-sync = {
          description = "Run the snapraid-btrfs sync with the runner";
          startAt = "01:00";
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${self.packages.${pkgs.system}.snapraid-btrfs-runner}/bin/snapraid-btrfs-runner";
          };
        };
      };
    };

    system.core.impermanence = {
      files = [
        "/var/snapraid.content"
      ];
      directories = [
        "/srv/"
        "/data/docker-volumes"
        "/data/torrents"
        "/var/qbittorrent"
        "/var/lib/jellyfin"
        "/var/lib/syncthing"
        "/var/lib/immich"
        "/var/lib/redis-immich"
        "/var/lib/postgresql"
        "/etc/zfs"
        "/root/.local/share/signal-cli"
      ];
    };
  };
}
