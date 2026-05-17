{
  pkgs,
  self,
  inputs,
  lib,
  config,
  ...
}:
let
  zedSignal = pkgs.writeShellScript "zed-signal" ''
        #!${pkgs.bash}/bin/bash

        HOST="$(hostname)"

        MESSAGE="ZFS event on $HOST

    Pool:    $ZEVENT_POOL
    Class:   $ZEVENT_SUBCLASS
    Time:    $(date)

    EID:     $ZEVENT_EID"


        ${pkgs.signal-cli}/bin/signal-cli \
          --config /home/nixos/.local/share/signal-cli \
          send -g "TO+DykH3guaqDHrFpJzM1QUQzSAfqBsEIgwVKrP74rQ=" \
          -m "$MESSAGE"
  '';
in
{
  imports = [
    ./hardware-configuration.nix
    ./disks.nix
  ];

  config = {
    custom = {
      user.name = "nixos";

      services = {
        postgresql = {
          backupLocation = "/mnt/storage/vault/postgresql";
        };

        syncthing = {
          devices = {
            "oliver" = {
              id = "EVZY72B-QB2I3KS-IQIXSPN-EV7Y3BX-TXJFDXZ-HISKJIB-MS6XVKT-QDDZQQS";
            };
            "enterprise" = {
              id = "4NW7R3L-2MNRG2Q-AZFFT2P-33FI6L3-T3FYW3P-S3GE3MR-PLI3OKP-CJTAFQ5";
            };
            "apollo" = {
              id = "YX2IAXK-3MDJKKG-O6NXVKH-V2RBIZX-5M4I73R-R65A6B6-QHX7OUU-ETH7EQB";
            };
            "ariane" = {
              id = "J23DJJ5-XXGSCKX-SRHBGRL-YOAGKNI-324SCVQ-MKRRANP-QDOYVWS-L3XWAQR";
            };
          };

          folders = {
            # Name of folder in Syncthing, also the folder ID
            "Oliver Photos" = {
              id = "hd1901_jc5r-photos";
              path = "/mnt/storage/vault/homes/Oliver/Syncthing/Photos"; # Which folder to add to Syncthing
              devices = [ "oliver" ]; # Which devices to share the folder with
            };

            "dev" = {
              id = "rrk9d-szxeq";
              path = "/mnt/storage/vault/backup/dev"; # Which folder to add to Syncthing
              devices = [ "enterprise" ]; # Which devices to share the folder with
              type = "receiveonly";
            };
          };
        };
      };
    };

    boot = {
      kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
      kernelModules = [
        "zfs"
        "coretemp"
        "it87"
      ];
      extraModulePackages = with pkgs.linuxPackages_latest; [ it87 ];
      supportedFilesystems = lib.mkForce [
        "btrfs"
        "zfs"
      ];
      resumeDevice = "/dev/disk/by-label/nixos";
      # sudo btrfs inspect-internal map-swapfile -r /swap/swapfile
      kernelParams = [
        "resume_offset=533760"
      ];

      extraModprobeConfig = ''
        options it87 force_id=0x8620
      '';

      zfs = {
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
        lm_sensors
        git
        pciutils
        mergerfs
        mergerfs-tools
        self.packages.${pkgs.stdenv.hostPlatform.system}.snapraid-btrfs
        self.packages.${pkgs.stdenv.hostPlatform.system}.snapraid-btrfs-runner
        signal-cli
      ];
    };

    networking = {
      hostName = "thor";
      nftables.enable = true;
      firewall = {
        allowedTCPPorts = [
          53
          80
          443
          2283
          3001
          3003
          4500
          8173
          8384
          8090
          22000
        ];
        allowedUDPPorts = [
          53
          80
          443
          2283
          3001
          3003
          4500
          22000
          21027
        ];
      };
    };

    security.tpm2.enable = true;

    hardware.sensor.hddtemp = {
      enable = true;
      drives = [
        "/dev/disk/by-id/ata-ST20000NM007D-3DJ103_WVT0XWWL"
        "/dev/disk/by-id/ata-HUH721212ALE601_8HJ6EGGH"
        "/dev/disk/by-id/ata-WDC_WUH721414ALE6L4_Y6GJ5Z5C"
      ];
    };

    services = {
      # for SSD/NVME
      fstrim.enable = true;

      getty.autologinUser = "nixos";

      zfs = {
        trim = {
          enable = true;
          interval = "weekly";
        };

        autoScrub = {
          enable = true;
          pools = [ "tank" ];
          interval = "weekly";
        };

        zed = {
          settings = {
            ZED_DEBUG_LOG = "/tmp/zed.debug.log";

            ZED_NOTIFY_INTERVAL_SECS = 3600;
            ZED_NOTIFY_VERBOSE = true;

            ZED_USE_ENCLOSURE_LEDS = true;
            ZED_SCRUB_AFTER_RESILVER = true;

            # Disable built-in mail handling
            ZED_EMAIL_ADDR = [ ];
            ZED_EMAIL_PROG = "";

            # Custom notifier
            ZED_NOTIFY_PROG = "${zedSignal}";
          };
        };
      };

      hddfancontrol = {
        enable = true;
        settings = {
          harddrives = {
            disks = [
              "/dev/disk/by-id/ata-ST20000NM007D-3DJ103_WVT0XWWL"
              "/dev/disk/by-id/ata-HUH721212ALE601_8HJ6EGGH"
              "/dev/disk/by-id/ata-WDC_WUH721414ALE6L4_Y6GJ5Z5C"
            ];
            # https://forums.servethehome.com/index.php?threads/12gen-n-series-nas-motherboard-topton-cwwk.42432/page-48#post-457741
            pwmPaths = [ "/sys/class/hwmon/hwmon4/device/pwm3" ];
            extraArgs = [
              "-i 30sec"
            ];
          };
        };
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
          ".Trash-1000/"
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
            ALLOW_GROUPS = [ "wheel" ];
            SYNC_ACL = true;
          };
          d2 = {
            SUBVOLUME = "/mnt/disk2";
            ALLOW_GROUPS = [ "wheel" ];
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
            User = "root";
            ExecStart = "${
              self.packages.${pkgs.stdenv.hostPlatform.system}.snapraid-btrfs-runner
            }/bin/snapraid-btrfs-runner";
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
        "/var/lib/immich"
        "/var/lib/redis-immich"
        "/var/lib/postgresql"
        "/etc/zfs"
        "/root/.local/share/signal-cli"
      ];
    };
  };
}
