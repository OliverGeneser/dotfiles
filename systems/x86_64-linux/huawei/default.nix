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
    hostName = "huawei";
  };

  suites = {
    gaming.enable = true;
    desktop = {
      enable = true;
      addons = {
        hyprland.enable = true;
      };
    };
    laptop.enable = true;
  };

  boot = {
    kernelParams = [
      "resume_offset=533760"
    ];
    supportedFilesystems = lib.mkForce ["btrfs"];
    kernelPackages = pkgs.linuxPackages_latest;
    resumeDevice = "/dev/disk/by-label/nixos";
  };

  nix.package = pkgs.nixVersions.git;

  system.stateVersion = "23.11";
}
