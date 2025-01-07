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
      jellyfin-server.enable = true;
      signal-reporting-bot.enable = true;
    };

    snapraid = {
      enable = true;
      dataDisks = {
        d1 = "/mnt/disk1";
        d2 = "/mnt/disk2";
      };
      contentFiles = [
        "/persist/var/snapraid/snapraid.content"
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
      directories = [
        "/srv/"
        "/var/snapraid/"
        "/var/lib/jellyfin"
        "/var/lib/syncthing"
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
    kernelPackages = pkgs.linuxPackages_6_6;
    resumeDevice = "/dev/disk/by-label/nixos";

    zfs = {
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
          User = "nixos";
          ExecStart = "${pkgs.custom.snapraid-btrfs-runner}/bin/snapraid-btrfs-runner";
          Nice = 19;
          IOSchedulingPriority = 7;
          CPUSchedulingPolicy = "batch";

          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateTmp = true;
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          RestrictAddressFamilies = "AF_UNIX";
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = "@system-service";
          SystemCallErrorNumber = "EPERM";
          CapabilityBoundingSet = "";
          ProtectSystem = "strict";
          ProtectHome = "read-only";
          ReadOnlyPaths = ["/etc/snapraid.conf" "/etc/snapper"];
          ReadWritePaths = [
            "/mnt/disk1"
            "/mnt/disk2"
            "/mnt/parity1/snapraid.parity"
            "/persist/var/snapraid"
            "/mnt/snapraid-content/disk1/snapraid.content"
            "/mnt/snapraid-content/disk2/snapraid.content"
          ];
        };
      };
    };
  };

  system.stateVersion = "23.11";
}
