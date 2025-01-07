{
  lib,
  modulesPath,
  inputs,
  pkgs,
  ...
}:
with lib;
with lib.custom; {
  imports = with inputs.nixos-hardware.nixosModules; [
    raspberry-pi-3
  ];

  boot = {
    initrd.availableKernelModules = ["xhci_pci" "usbhid" "usb_storage"];
    supportedFilesystems = lib.mkForce ["vfat" "btrfs" "tmpfs"];
  };

  networking = {
    hostName = "tunnelboy";
  };

  system = {
    boot.enable = lib.mkForce false;
    impermanence.enable = lib.mkForce false;
  };

  roles = {
    server.enable = true;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = ["noatime"];
    };
  };

  environment.systemPackages = with pkgs; [vim];

  sdImage.compressImage = false;
  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "23.11";
}
