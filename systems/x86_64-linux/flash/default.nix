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
    hostName = "flash";
  };

  roles = {
    server.enable = true;
  };

  cli = {
    programs = {
      disk-burnin.enable = true;
    };
  };

  boot = {
    kernelParams = [
      "resume_offset=533760" # sudo -E -s btrfs inspect-internal map-swapfile -r /swap/swapfile
    ];
    supportedFilesystems = lib.mkForce ["btrfs"];
    kernelModules = [];
    kernelPackages = pkgs.linuxPackages_latest;
    resumeDevice = "/dev/disk/by-label/nixos";
  };

  system.stateVersion = "23.11";
}
