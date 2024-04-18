{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disks.nix

    ../../nixos
    ../../nixos/users/olivergeneser.nix
  ];

  networking = {
    hostName = "huawei";
  };

  modules.nixos = {
    auto-hibernate.enable = false;
    bluetooth.enable = true;
    login.enable = true;
    extraSecurity.enable = true;
    power.enable = true;
  };

  boot = {
    kernelParams = [
      "resume_offset=533760"
    ];
    supportedFilesystems = lib.mkForce ["btrfs"];
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    resumeDevice = "/dev/disk/by-label/nixos";
    initrd.systemd.enable = true;
    # lanzaboote = {
    #   enable = true;
    #   pkiBundle = "/etc/secureboot";
    # };
  };

  boot.plymouth = {
    enable = true;
    themePackages = [(pkgs.catppuccin-plymouth.override {variant = "mocha";})];
    theme = "catppuccin-mocha";
  };

  system.stateVersion = "23.11";
}
