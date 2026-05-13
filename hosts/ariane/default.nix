{
  pkgs,
  self,
  inputs,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./disks.nix
    ./hyprland.nix
    ./battery.nix
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-13th-gen
    ../../system/programs/dev/krb5.nix
  ];

  boot = {
    kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
    supportedFilesystems = lib.mkForce [ "btrfs" ];
    resumeDevice = "/dev/disk/by-label/nixos";
    # sudo btrfs inspect-internal map-swapfile -r /swap/swapfile
    kernelParams = [
      "resume_offset=21767424"
    ];
    extraModprobeConfig = ''
      # example settings
      options snd-hda-intel model=alc256-headset
    '';
  };

  environment = {
    # nh default flake
    variables.NH_FLAKE = "/home/olivergeneser/dotfiles";

    systemPackages = with pkgs; [
    ];
  };

  networking = {
    hostName = "ariane";
    nftables.enable = true;
    firewall = {
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
  };

  security.tpm2.enable = true;

  services = {
    # for SSD/NVME
    fstrim.enable = true;
  };
}
