{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disks.nix
  ];

  networking = {
    hostName = "thor";
  };

  roles = {
    server.enable = true;
  };

  services = {
    custom = {
      homepage.enable = true;
      radarr.enable = true;
      syncthing.enable = true;
      nextcloud.enable = true;
      immich.enable = true;
      jellyfin-server.enable = true;
      signal-reporting-bot.enable = true;
      postgresql = {
        enable = true;
        databases = ["immich"];
        backupLocation = "/mnt/storage/vault/postgresql";
      };
      virtualisation.gluetun.enable = true; # For linux ISO's
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

  system = {
    impermanence = {
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

  hardware = {
    custom = {
      networking = {
        allowedTCPPorts = [80 443 8173 8384 22000];
        allowedUDPPorts = [80 443 22000 21027];
      };
    };
  };

  boot = {
    kernelParams = [
      "resume_offset=533760" # sudo -E -s btrfs inspect-internal map-swapfile -r /swap/swapfile
    ];
    supportedFilesystems = lib.mkForce ["btrfs" "zfs"];
    kernelModules = ["zfs"];
    kernelPackages = pkgs.linuxPackages_6_13;
    resumeDevice = "/dev/disk/by-label/nixos";

    zfs = {
      package = pkgs.zfs_2_3;
      forceImportAll = false;
      forceImportRoot = false;
    };
  };

  services.zfs = {
    trim.enable = true;
    trim.interval = "weekly";

    autoScrub.enable = true;
    autoScrub.pools = ["tank"];
    autoScrub.interval = "weekly";
  };

  environment = {
    systemPackages = with pkgs;
    with pkgs.custom; [
      nfs-utils
      xfsprogs
      e2fsprogs
      dnsutils
      smartmontools
      git
      pciutils
      mergerfs
      mergerfs-tools
      snapraid-btrfs
      snapraid-btrfs-runner
    ];
  };

  systemd = {
    services = {
      snapraid-btrfs-sync = {
        description = "Run the snapraid-btrfs sync with the runner";
        startAt = "01:00";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.custom.snapraid-btrfs-runner}/bin/snapraid-btrfs-runner";
        };
      };
    };
  };

  system.stateVersion = "23.11";
}
