{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.roles.server;
in {
  options.roles.server = {
    enable = mkEnableOption "Enable server configuration";
  };

  config = mkIf cfg.enable {
    roles = {
      common.enable = true;
    };

    cli = {
      programs = {
        nh.enable = true;
      };
    };

    custom = {
      services = {
        radarr.enable = true;
        nextcloud.enable = true;
      };
    };

    services = {
      getty.autologinUser = "nixos";
      jellyfin-server.enable = true;
      signal-reporting-bot.enable = true;

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
          disk1 = {
            SUBVOLUME = "/mnt/disk1";
            ALLOW_GROUPS = ["wheel"];
            SYNC_ACL = true;
          };
          disk2 = {
            SUBVOLUME = "/mnt/disk2";
            ALLOW_GROUPS = ["wheel"];
            SYNC_ACL = true;
          };
        };
      };
    };

    environment =
      {
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

        # Print the URL instead on servers
        variables.BROWSER = "echo";
      }
      // lib.optionalAttrs (lib.versionAtLeast (lib.versions.majorMinor lib.version) "23.11") {
        # Don't install the /lib/ld-linux.so.2 and /lib64/ld-linux-x86-64.so.2
        # stubs. Server users should know what they are doing.
        stub-ld.enable = lib.mkDefault false;
      };

    #/mnt/disk* /mnt/storage fuse.mergerfs defaults,nonempty,allow_other,use_ino,cache.files=off,moveonenospc=true,category.create=mfs,dropcacheonclose=true,minfreespace=250G,fsname=mergerfs 0 0
    fileSystems."/mnt/storage" = {
      fsType = "fuse.mergerfs";
      device = "/mnt/disk*";
      options = ["defaults" "nofail" "nonempty" "allow_other" "use_ino" "cache.files=partial" "moveonenospc=true" "category.create=mfs" "dropcacheonclose=true" "minfreespace=250G" "fsname=mergerfs"];
    };

    security = {
      sudo = {
        wheelNeedsPassword = false;
        # Only allow members of the wheel group to execute sudo by setting the executable’s permissions accordingly. This prevents users that are not members of wheel from exploiting vulnerabilities in sudo such as CVE-2021-3156.
        execWheelOnly = true;
        # Don't lecture the user. Less mutable state.
        extraConfig = ''
          Defaults lecture = never
        '';
      };
    };

    # Notice this also disables --help for some commands such es nixos-rebuild
    documentation = {
      enable = lib.mkDefault false;
      info.enable = lib.mkDefault false;
      man.enable = lib.mkDefault false;
      nixos.enable = lib.mkDefault false;
    };

    # No need for fonts on a server
    fonts.fontconfig.enable = lib.mkDefault false;

    # UTC everywhere!
    time.timeZone = lib.mkDefault "UTC";

    # No mutable users by default
    users.mutableUsers = false;

    systemd = {
      services = {
        NetworkManager-wait-online.enable = false;
        snapraid-btrfs-sync = {
          description = "Run the snapraid-btrfs sync with the runner";
          startAt = "01:00";
          serviceConfig = {
            Type = "oneshot";
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
              "/persist/var/snapraid.content"
              "/mnt/snapraid-content/disk1/snapraid.content"
              "/mnt/snapraid-content/disk2/snapraid.content"
            ];
          };
        };
      };

      network.wait-online.enable = false;
      tmpfiles.rules = [
        "L+ /usr/local/bin - - - - /run/current-system/sw/bin/"
      ];

      # Given that our systems are headless, emergency mode is useless.
      # We prefer the system to attempt to continue booting so
      # that we can hopefully still access it remotely.
      enableEmergencyMode = false;

      # For more detail, see:
      #   https://0pointer.de/blog/projects/watchdog.html
      watchdog = {
        # systemd will send a signal to the hardware watchdog at half
        # the interval defined here, so every 10s.
        # If the hardware watchdog does not get a signal for 20s,
        # it will forcefully reboot the system.
        runtimeTime = "20s";
        # Forcefully reboot if the final stage of the reboot
        # hangs without progress for more than 30s.
        # For more info, see:
        #   https://utcc.utoronto.ca/~cks/space/blog/linux/SystemdShutdownWatchdog
        rebootTime = "30s";
      };
    };

    # use TCP BBR has significantly increased throughput and reduced latency for connections
    boot.kernel.sysctl = {
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
    };

    user = {
      name = "nixos";
      initialPassword = "1";
    };
  };
}
