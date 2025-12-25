{
  pkgs,
  self,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disks.nix
    ./hyprland.nix
    ./nvidia.nix
    ./battery.nix
    inputs.nixos-hardware.nixosModules.huawei-machc-wa
  ];

  boot = {
    kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
    supportedFilesystems = lib.mkForce ["btrfs"];
    resumeDevice = "/dev/disk/by-label/nixos";
    # sudo btrfs inspect-internal map-swapfile -r /swap/swapfile
    kernelParams = [
      "resume_offset=533760"
    ];
  };

  # nh default flake
  environment.variables.NH_FLAKE = "/home/olivergeneser/dotfiles";

  networking = {
    hostName = "apollo";
    nftables.enable = true;
    firewall = {
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
  };

  security.tpm2.enable = true;

  services = {
    # for SSD/NVME
    fstrim.enable = true;
  };
}
