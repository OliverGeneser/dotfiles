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
  };

  environment.systemPackages = with pkgs; [
  ];

  boot = {
    kernelParams = [
      "resume_offset=533760"
    ];
    supportedFilesystems = lib.mkForce ["btrfs"];
    kernelPackages = pkgs.linuxPackages_latest;
    resumeDevice = "/dev/disk/by-label/nixos";
  };

  system.boot = {
    enable = lib.mkForce true;
    plymouth = lib.mkForce true;
    #secureBoot = lib.mkForce true;
  };

  system.stateVersion = "23.11";
}
