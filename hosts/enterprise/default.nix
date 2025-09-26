{
  pkgs,
  self,
  # inputs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disks.nix
    ./hyprland.nix
  ];

  environment = {
    systemPackages = with pkgs; [
      alsa-scarlett-gui
    ];
  };

  boot = {
    kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
    supportedFilesystems = lib.mkForce ["btrfs" "ntfs"];
    resumeDevice = "/dev/disk/by-label/nixos";
    # sudo filefrag -v /swap/swapfile | awk '$1=="0:" {print substr($4, 1, length($4)-2)}'
    kernelParams = [
      "resume_offset=269568"
    ];
  };

  # nh default flake
  environment.variables.NH_FLAKE = "/home/olivergeneser/dotfiles";

  networking = {
    hostName = "enterprise";
    nftables.enable = true;
    firewall = {
      allowedTCPPorts = [3000 3005 8080 8081 4200];
      allowedUDPPorts = [4200 8081];
    };
  };

  security.tpm2.enable = true;

  services = {
    # for SSD/NVME
    fstrim.enable = true;

    getty.autologinUser = "olivergeneser";
  };
}
