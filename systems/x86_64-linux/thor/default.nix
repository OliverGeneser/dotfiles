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
    };
  };

  system = {
    impermanence = {
      directories = [
        "/srv/"
        "/var/snapraid/"
        "/var/lib/jellyfin"
        "/etc/zfs"
        "/root/.local/share/signal-cli"
      ];
    };
  };

  hardware = {
    networking = {
      allowedTCPPorts = [80 443 8173 8384 22000];
      allowedUDPPorts = [80 443 22000 21027];
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

  system.stateVersion = "23.11";
}
