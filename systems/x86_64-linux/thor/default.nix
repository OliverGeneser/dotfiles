{ inputs
, pkgs
, lib
, ...
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

  boot = {
    kernelParams = [
      "resume_offset=533760" # sudo -E -s btrfs inspect-internal map-swapfile -r /swap/swapfile
    ];
    supportedFilesystems = lib.mkForce [ "btrfs" "zfs" ];
    kernelModules = [ "zfs" ];
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
    autoScrub.pools = [ "tank" ];
    autoScrub.interval = "weekly";
  };

  system.stateVersion = "23.11";
}
