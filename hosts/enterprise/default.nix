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
    kernelParams = [
      "resume_offset=533760"
    ];
  };

  # nh default flake
  environment.variables.NH_FLAKE = "/home/olivergeneser/dotfiles";

  networking = {
    hostName = "enterprise";
    nftables.enable = true;
    firewall = {
      allowedTCPPorts = [3000 3005 8080 4200];
      allowedUDPPorts = [4200];
    };
  };

  security.tpm2.enable = true;

  services = {
    # for SSD/NVME
    fstrim.enable = true;
  };
}
