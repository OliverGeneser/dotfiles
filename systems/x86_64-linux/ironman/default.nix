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
    hostName = "ironman";
  };

  roles = {
    server.enable = true;
  };

  boot = {
    kernelParams = [
      "resume_offset=533760"
    ];
    supportedFilesystems = lib.mkForce [ "btrfs" "zfs" ];
    kernelModules = [ "zfs" ];
    kernelPackages = pkgs.linuxPackages_latest;
    resumeDevice = "/dev/disk/by-label/nixos";

    zfs = {
      package = pkgs.zfs_unstable;
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
